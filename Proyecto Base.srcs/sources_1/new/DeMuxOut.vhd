----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2022 22:14:15
-- Design Name: 
-- Module Name: DeMuxOut - Behavioral
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

entity DeMuxOut is
    Port ( write_ram : in STD_LOGIC;
           ram_address : in STD_LOGIC_VECTOR (11 downto 0);
           Load_Dis : out STD_LOGIC;
           Load_Led : out STD_LOGIC;
           Load_Lcd : out STD_LOGIC);
end DeMuxOut;

architecture Behavioral of DeMuxOut is

signal OUTPUT: STD_LOGIC_VECTOR (2 downto 0);

begin

Load_Dis <= OUTPUT(0);
Load_Led <= OUTPUT(1);
Load_Lcd <= OUTPUT(2);

with ram_address select
    OUTPUT <= '0' & '0' & write_ram  when "000000000010",
              '0' & write_ram & '0' when "000000000000",
              write_ram & '0' & '0' when "000000000111",
              "000"  when others;
              


end Behavioral;
