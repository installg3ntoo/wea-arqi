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

entity MUXIN is
    Port ( sw : in STD_LOGIC_VECTOR (15 downto 0);
           btn : in STD_LOGIC_VECTOR (15 downto 0);
           seg : in STD_LOGIC_VECTOR (15 downto 0);
           mseg : in STD_LOGIC_VECTOR (15 downto 0);
           useg : in STD_LOGIC_VECTOR (15 downto 0);
           ram : in STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (11 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (15 downto 0));
end MUXIN;

architecture Behavioral of MUXIN is

begin

with ram_dataout select
    OUTPUT <= sw when "000000000001",
              btn when "000000000011",
              seg when "000000000100",
              mseg when "000000000101",
              useg when "000000000111",
              ram  when others;
              

end Behavioral;