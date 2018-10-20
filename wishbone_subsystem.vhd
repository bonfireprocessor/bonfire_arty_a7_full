---------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/16/2017 03:32:41 PM
-- Design Name: 
-- Module Name: wishbone_subsystem - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wishbone_subsystem is
Port(

      
       -- UART0 signals:
       --uart0_txd : out std_logic;
       --uart0_rxd : in  std_logic :='1';
       
       -- SPI flash chip
       flash_spi_cs        : out   std_logic;
       flash_spi_clk       : out   std_logic;
       flash_spi_mosi      : out   std_logic;
       flash_spi_miso      : in    std_logic;
       
       -- IRQ Controller 
       ether_irq_in : in std_logic;
       ether_irq_out : out std_logic;
       
       
       -- Wishbone Slave 
       clk_i: in std_logic;
       rst_i: in std_logic;

       wb_cyc_i: in std_logic;
       wb_stb_i: in std_logic;
       wb_we_i: in std_logic;
       wb_sel_i : in std_logic_vector(3 downto 0);
       wb_ack_o: out std_logic;
       wb_adr_i: in std_logic_vector(31 downto 2); -- only bits 29 downto 2 are used !
       wb_dat_i: in std_logic_vector(31 downto 0);
       wb_dat_o: out std_logic_vector(31 downto 0)
       
);       
end wishbone_subsystem;

architecture Behavioral of wishbone_subsystem is

-- Attribute Infos for Xilinx Vivado IP Integrator Block designs
-- Should not have negative influence on other platforms. 

ATTRIBUTE X_INTERFACE_INFO : STRING;
ATTRIBUTE X_INTERFACE_INFO of  clk_i : SIGNAL is "xilinx.com:signal:clock:1.0 clk_i CLK";
--ATTRIBUTE X_INTERFACE_INFO of  rst_i : SIGNAL is "xilinx.com:signal:reset:1.0 rst_i RESET";

ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
ATTRIBUTE X_INTERFACE_PARAMETER of clk_i : SIGNAL is "ASSOCIATED_BUSIF WB_DB";
--ATTRIBUTE X_INTERFACE_PARAMETER of rst_i : SIGNAL is "ASSOCIATED_BUSIF WB_DB";

ATTRIBUTE X_INTERFACE_INFO OF wb_cyc_i: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0 WB_DB wb_dbus_cyc_o";
ATTRIBUTE X_INTERFACE_INFO OF wb_stb_i: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0 WB_DB wb_dbus_stb_o";
ATTRIBUTE X_INTERFACE_INFO OF wb_we_i: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0  WB_DB wb_dbus_we_o";
ATTRIBUTE X_INTERFACE_INFO OF wb_sel_i: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0 WB_DB wb_dbus_sel_o";
ATTRIBUTE X_INTERFACE_INFO OF wb_ack_o: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0 WB_DB wb_dbus_ack_i";
ATTRIBUTE X_INTERFACE_INFO OF wb_adr_i: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0 WB_DB wb_dbus_adr_o";
ATTRIBUTE X_INTERFACE_INFO OF wb_dat_i: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0 WB_DB wb_dbus_dat_o";
ATTRIBUTE X_INTERFACE_INFO OF wb_dat_o: SIGNAL IS "bonfire.eu:wb:Wishbone_master:1.0 WB_DB wb_dbus_dat_i";
  


signal lpc_dat_rd8, lpc_dat_wr8 : std_logic_vector(7 downto 0);

--signal uart_cyc,uart_stb,uart_we,uart_ack : std_logic;
--signal uart_sel :  std_logic_vector(3 downto 0);
--signal uart_dat_rd,uart_dat_wr : std_logic_vector(7 downto 0);
--signal uart_adr : std_logic_vector(7 downto 0);

-- SPI Flash
signal flash_cyc,flash_stb,flash_we,flash_ack : std_logic;
signal flash_sel :  std_logic_vector(3 downto 0);
signal flash_dat_rd,flash_dat_wr : std_logic_vector(7 downto 0);
signal flash_adr : std_logic_vector(7 downto 0);

-- sys controller
signal sys_cyc, sys_stb,sys_we,sys_ack : std_logic;
signal sys_sel :  std_logic_vector(3 downto 0);
signal sys_dat_rd,sys_dat_wr : std_logic_vector(7 downto 0);
signal sys_adr : std_logic_vector(7 downto 0);


signal temp_adr : std_logic_vector (29 downto 0);

begin


 lpc_dat_wr8 <= wb_dat_i(7 downto 0);
 wb_dat_o <=  X"000000"&lpc_dat_rd8;
 
 temp_adr <= wb_adr_i(29 downto 2) & "00";

inst_wb_io:  entity work.wb_io PORT MAP(
           clk_i => clk_i,
           rst_i => rst_i,
           
           s0_cyc_i => wb_cyc_i,
           s0_stb_i => wb_stb_i,
           s0_we_i =>  wb_we_i,
           s0_ack_o => wb_ack_o,
           s0_adr_i => temp_adr ,
           s0_dat_i =>  lpc_dat_wr8,
           s0_dat_o =>  lpc_dat_rd8,
           
           m0_cyc_o =>  open,
           m0_stb_o => open,
           m0_we_o =>  open,
           m0_ack_i => '1',
           m0_adr_o => open,
           m0_dat_o => open ,
           m0_dat_i => (others=>'0'),
           
           m1_cyc_o =>  flash_cyc,
           m1_stb_o => flash_stb,
           m1_we_o =>  flash_we,
           m1_ack_i => flash_ack,
           m1_adr_o => flash_adr,
           m1_dat_o => flash_dat_wr,
           m1_dat_i => flash_dat_rd,
           
           m2_cyc_o => sys_cyc,
           m2_stb_o => sys_stb,
           m2_we_o =>  sys_we,
           m2_ack_i => sys_ack,
           m2_adr_o => sys_adr,
           m2_dat_o => sys_dat_wr,
           m2_dat_i => sys_dat_rd
       );
       
--   inst_uart:  entity work.wb_uart_interface
--    generic map(
  
--        FIFO_DEPTH => 64 )
  
  
--  PORT MAP(
--       clk =>clk_i ,
--       reset => rst_i,
--       txd => open,
--       rxd => '1',
--       irq => open,
--       wb_adr_in => uart_adr,
--       wb_dat_in => uart_dat_wr,
--       wb_dat_out => uart_dat_rd,
--       wb_we_in => uart_we,
--       wb_cyc_in => uart_cyc,
--       wb_stb_in => uart_stb,
--       wb_ack_out => uart_ack
--   );
   
--   inst_flash : entity work.wb_spi_interface 
--   PORT MAP(
--       clk_i => clk_i,
--       reset_i => rst_i,
--       slave_cs_o => flash_spi_cs,
--       slave_clk_o => flash_spi_clk,
--       slave_mosi_o => flash_spi_mosi,
--       slave_miso_i => flash_spi_miso,
--       irq => open,
--       wb_adr_in =>flash_adr ,
--       wb_dat_in => flash_dat_wr,
--       wb_dat_out => flash_dat_rd,
--       wb_we_in => flash_we,
--       wb_cyc_in => flash_cyc,
--       wb_stb_in => flash_stb,
--       wb_ack_out => flash_ack
--   );
   
   
      
   inst_flash : entity work.bonfire_spi
   GENERIC MAP (
     WB_DATA_WIDTH=>8,
     ADR_LOW=>2
   )
   PORT MAP(
       wb_clk_i => clk_i,
       spi_clk_i =>clk_i,
       wb_rst_i => rst_i,
       slave_cs_o => flash_spi_cs,
       slave_clk_o => flash_spi_clk,
       slave_mosi_o => flash_spi_mosi,
       slave_miso_i => flash_spi_miso,
       irq => open,
       wb_adr_in =>flash_adr(4 downto 2),
       wb_dat_in => flash_dat_wr,
       wb_dat_out => flash_dat_rd,
       wb_we_in => flash_we,
       wb_cyc_in => flash_cyc,
       wb_stb_in => flash_stb,
       wb_ack_out => flash_ack
   );
   
   inst_sys : entity work.bonfire_axi_sysio 
   PORT MAP (
      clk_i => clk_i,
      rst_i => rst_i,
      wbs_adr_i =>sys_adr ,
      wbs_dat_i => sys_dat_wr,
      wbs_dat_o => sys_dat_rd,
      wbs_we_i => sys_we,
      wbs_cyc_i => sys_cyc,
      wbs_stb_i => sys_stb,
      wbs_ack_o => sys_ack,
      ethernet_irq_i => ether_irq_in,
      irq_req_o => ether_irq_out );
   
   
   
   


end Behavioral;
