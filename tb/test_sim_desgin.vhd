library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

LIBRARY std;
USE std.textio.all;

use work.txt_util.all;

entity test_sim_design is 
end test_sim_design;


architecture TB of test_sim_design is

--constant bit_time : time := 8.68 us;
constant bit_time : time := 2.004 us; -- 500.000 Bit/sec


component sim_design is
port (
   RX : in STD_LOGIC;
   Result : out STD_LOGIC_VECTOR ( 31 downto 0 );
   TX : out STD_LOGIC;
   finished : out STD_LOGIC
);
end component sim_design;

component tb_uart_capture_tx is
generic (
  baudrate : natural := 500000;
  bit_time : time := bit_time;
  SEND_LOG_NAME : string := "send.log";
  stop_mark : std_logic_vector(7 downto 0) -- Stop marker byte
);
port (
  txd : in std_logic;
  stop : out boolean; -- will go to true when a stop marker is found
  framing_errors : out natural;
  total_count : out natural
);

end component tb_uart_capture_tx;

signal Result : STD_LOGIC_VECTOR (31 downto 0);
signal finished : STD_LOGIC;
signal TX : STD_LOGIC;
signal RX : STD_LOGIC :='1';
signal framing_errors, total_count : natural;
signal uart_stop : boolean;

subtype t_byte is std_logic_vector(7 downto 0);
signal cbyte : t_byte;
signal bitref : integer :=0;

begin

 -- RX<=TX; -- Loopback
  
  
  -- Simulates a serial bit stream to the rxd pin
     rxd_sim: process
        procedure send_byte(v: std_logic_vector(7 downto 0)) is
        variable bi : integer;
        variable t : std_logic_vector(7 downto 0);
        begin
  
          bi:=7;
          for i in 0 to 7 loop
           t(bi) := v(i); -- for debugging purposes
           bi:=bi-1;
          end loop;
          cbyte <= t;
  
          bitref<= 0;
  
          RX <= '0'; -- start bit
          for i in 0 to 7 loop
            wait for bit_time;
            RX<=v(i);
            bitref<=bitref+1;
          end loop;
          wait for bit_time;
          RX <= '1'; -- stop bit
          bitref<=bitref+1;
          wait for bit_time;
        end;
  
        procedure sendstring(s:string) is
        begin
          for i in 1 to s'length loop
            send_byte(std_logic_vector(to_unsigned(character'pos(s(i)),8)));
          end loop;
        end;
  
     begin
         
         wait until uart_stop; -- Wait for send test to finish
--         for i in 0 to 100 loop
--           send_byte("01010101");
--         end loop;  
         for i in 32 to 126 loop
          send_byte(std_logic_vector(to_unsigned(i,8)));
         end loop;
         send_byte(X"0A");
  
--         -- Send a string to the UART receiver pin
--         sendstring(Teststr);
--         wait for bit_time*10; -- give some time for the receive process
--         receive_test_finish<=true; -- signal end of send simulation
         wait;
  
     end process;

  
  
  
  

UART_CAPTURE: component tb_uart_capture_tx 
generic map (
  stop_mark => X"0A" -- line feed 
)
port map (
  txd => TX,
  framing_errors => framing_errors,
  total_count => total_count,
  stop => uart_stop
);

process begin
   wait until uart_stop;
   print(OUTPUT,"UART Test captured bytes: " & str(total_count) & " framing errors: " & str(framing_errors));
end process;


DUT: component sim_design port map (
  Result => Result,
  finished => finished,
  TX => TX,
  RX => RX
);


process begin
 

  wait until finished='1';
  report "Run completed";
end process;

end TB;

