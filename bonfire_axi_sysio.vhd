----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2017 07:30:51 PM
-- Design Name: 
-- Module Name: bonfire_axi_sysio - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bonfire_axi_sysio is
generic (
   SYS_ID : std_logic_vector(7 downto 0):=X"10"
  
);
Port (
   clk_i: in std_logic;
   rst_i: in std_logic;
   
   ethernet_irq_i: in  std_logic;
  
   irq_req_o: out std_logic ; 
   
   -- Slave Interface 
   
   wbs_cyc_i : in std_logic ;
   wbs_stb_i : in std_logic ;
   wbs_we_i : in std_logic ;
  
   wbs_ack_o : out std_logic ;
   wbs_adr_i : in std_logic_vector(7 downto 0);
   
   wbs_dat_o : out std_logic_vector(7 downto 0);
   wbs_dat_i : in std_logic_vector(7 downto 0)
);   
end bonfire_axi_sysio;

architecture Behavioral of bonfire_axi_sysio is

signal ether_irq_pending : std_logic :='0';
signal ack_read :  std_logic :='0';

begin

 wbs_ack_o <= ack_read or (wbs_we_i and wbs_stb_i);
 
 irq_req_o <= ether_irq_pending;

 process(clk_i) begin
   if rising_edge(clk_i) then
     if rst_i='1' then
       ether_irq_pending <= '0';
       ack_read<='0';
     else
       if ack_read='1' then
         ack_read<='0';
       elsif wbs_stb_i='1' and wbs_we_i='0' then
          -- Read registers
          ack_read<='1';  
          if  wbs_adr_i(7 downto 4)="0000" then
              case wbs_adr_i(3 downto 2) is
                when "00" =>
                  wbs_dat_o<="0000000"&ether_irq_pending;
                when "01" =>
                  wbs_dat_o <=  SYS_ID;
                when others=>
                  wbs_dat_o <= (others=>'0');
              end case;      
          end if;  
       end if;  
     
       -- Handle pending IRQ Bit
       if wbs_stb_i='1' and  wbs_we_i='1' and  wbs_adr_i(7 downto 2)="000000" and  wbs_dat_i(0)='1' then
         -- Clear pending IRQ with writing a '1 to the pending bit
          ether_irq_pending<='0';
       elsif ethernet_irq_i='1' then
         ether_irq_pending<='1';  
       end if;   
     end if;  
 
   end if;
 
 end process;


end Behavioral;
