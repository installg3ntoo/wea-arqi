----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.09.2022 19:55:39
-- Design Name: 
-- Module Name: MUX16x4 - Behavioral
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

entity MUX16x4 is
    Port ( I1 : in STD_LOGIC_VECTOR (15 downto 0);
           I2 : in STD_LOGIC_VECTOR (15 downto 0);
           I3 : in STD_LOGIC_VECTOR (15 downto 0);
           I4 : in STD_LOGIC_VECTOR (15 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (15 downto 0));
end MUX16x4;

architecture Behavioral of MUX16x4 is

begin

with SEL select
    OUTPUT <= I1 when "00",
              I2 when "01",
              I3 when "10",
              I4 when "11";
              

end Behavioral;
