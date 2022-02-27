-- Memory module to be synthesized as block RAM
-- can be initalized with a file

-- New "single process" version as recommended by Xilinx XST user guide


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library STD;
use STD.textio.all;


entity BootMem is
    generic (RamFileName : string := "meminit.ram";
             mode : string := "B";
             ADDR_WIDTH: integer;
             SIZE : integer;
             Swapbytes : boolean; -- SWAP Bytes in RAM word in low byte first order to use data2mem
             EnableSecondPort : boolean := true -- enable inference of the second port
            );
    Port ( A_DOUT : out  STD_LOGIC_VECTOR (31 downto 0);
           A_DIN : in  STD_LOGIC_VECTOR (31 downto 0);
           A_ADDR : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           A_EN : in  STD_LOGIC;
           A_WE : in  STD_LOGIC_VECTOR (3 downto 0);
           A_CLK : in  STD_LOGIC;
           -- Second Port ( read only)
           B_CLK : in STD_LOGIC;
           B_EN : in STD_LOGIC;
           B_ADDR : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           B_DOUT : out  STD_LOGIC_VECTOR (31 downto 0)

              );
end BootMem;


architecture Behavioral of BootMem is

attribute keep_hierarchy : string;
attribute keep_hierarchy of Behavioral: architecture is "TRUE";


ATTRIBUTE X_INTERFACE_INFO : STRING;
--ATTRIBUTE X_INTERFACE_INFO of  A_CLK : SIGNAL is "xilinx.com:signal:clock:1.0 A_CLK CLK";
--ATTRIBUTE X_INTERFACE_INFO of  B_CLK : SIGNAL is "xilinx.com:signal:clock:1.0 B_CLK CLK";

ATTRIBUTE X_INTERFACE_INFO of A_CLK : SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_A CLK";
ATTRIBUTE X_INTERFACE_INFO OF A_EN : SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_A EN";
ATTRIBUTE X_INTERFACE_INFO OF A_DOUT: SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_A DOUT";
ATTRIBUTE X_INTERFACE_INFO OF A_DIN: SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_A DIN";
ATTRIBUTE X_INTERFACE_INFO OF A_WE: SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_A WE";
ATTRIBUTE X_INTERFACE_INFO OF A_ADDR: SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_A ADDR";
  
ATTRIBUTE X_INTERFACE_INFO of B_CLK : SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_B CLK";  
ATTRIBUTE X_INTERFACE_INFO OF B_EN : SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_B EN";
ATTRIBUTE X_INTERFACE_INFO OF B_DOUT : SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_B DOUT";
ATTRIBUTE X_INTERFACE_INFO OF B_ADDR : SIGNAL IS "xilinx.com:interface:bram:1.0 BRAM_B ADDR";


ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
--ATTRIBUTE X_INTERFACE_PARAMETER of A_CLK : SIGNAL is "ASSOCIATED_BUSIF BRAM_A";
--ATTRIBUTE X_INTERFACE_PARAMETER of B_CLK : SIGNAL is "ASSOCIATED_BUSIF BRAM_B";

type tRam is array (0 to SIZE-1) of STD_LOGIC_VECTOR (31 downto 0);
subtype tWord is std_logic_vector(31 downto 0);


signal DOA,DOB,DIA : tWord;
signal WEA : STD_LOGIC_VECTOR (3 downto 0);


function doSwapBytes(d : tWord) return tWord is
begin

    return d(7 downto 0)&d(15 downto 8)&d(23 downto 16)&d(31 downto 24);

end;


-- Design time code...
-- Initalizes block RAM form memory file
-- The file does either contain hex values (mode = 'H') or binary values

impure function InitFromFile  return tRam is
FILE RamFile : text is in RamFileName;
variable RamFileLine : line;
variable word : tWord;
variable r : tRam;

begin
  for I in tRam'range loop
    if not endfile(RamFile) then
      readline (RamFile, RamFileLine);
        if mode="H" then
           hread (RamFileLine, word); -- alternative: HEX read
        else
         read(RamFileLine,word);  -- Binary read
      end if;
       if SwapBytes then
         r(I) :=  DoSwapBytes(word);
       else
         r(I) := word;
       end if;
     else
       r(I) := (others=>'0');
    end if;
  end loop;
  return r;
end function;

signal ram : tRam := InitFromFile;

attribute ram_style: string; -- for Xilinx
attribute ram_style of ram: signal is "block";


-- helper component
---- for byte swapping
--COMPONENT byte_swapper
--    PORT(
--        din : IN std_logic_vector(31 downto 0);
--        dout : OUT std_logic_vector(31 downto 0)
--        );
--    END COMPONENT;



begin

   swap: if SwapBytes generate
     -- The Data input bus is swapped with the helper component to avoid
     -- confusing the xilinx synthesis tools which sometimes infer distributed
     -- instead of block RAM
     -- It is important that the byte swapper component has set the keep_hierarchy attribute to TRUE
     -- this will make the byte swap of the input bus invisble for the RAM inference
--     bs: byte_swapper PORT MAP(
--        din => A_DIN,
--        dout => DIA
--      );

     DIA<=DoSwapBytes(A_DIN);
     
     A_DOUT<=DoSwapBytes(DOA);
     B_DOUT<=DoSwapBytes(DOB);
     WEA(0)<=A_WE(3);
     WEA(1)<=A_WE(2);
     WEA(2)<=A_WE(1);
     WEA(3)<=A_WE(0);

   end generate;

   noswap: if not SwapBytes generate
     DIA<=A_DIN;
     A_DOUT<=DOA;
     B_DOUT<=DOB;
     WEA<=A_WE;
   end generate;




  process(A_CLK)
  variable adr : integer;
  begin
    if rising_edge(A_CLK) then
        if A_EN = '1' then
           adr :=  to_integer(unsigned(A_ADDR));

           for i in 0 to 3 loop
             if WEA(i) = '1' then
                ram(adr)((i+1)*8-1 downto i*8)<= DIA((i+1)*8-1 downto i*8);
             end if;
           end loop;

           DOA <= ram(adr);

         end if;
     end if;

  end process;

  portb:  if EnableSecondPort generate

     process(B_CLK) begin
        if rising_edge(B_CLK) then
            if B_EN='1' then
               DOB <= ram(to_integer(unsigned(B_ADDR)));
             end if;
         end if;
     end process;

  end generate;

end Behavioral;

