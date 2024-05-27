----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2022 19:22:29
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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

entity ControlUnit is
    Port ( rom_dataout : in STD_LOGIC_VECTOR (19 downto 0);
           StaCU : in STD_LOGIC_VECTOR (2 downto 0);
           enableA : out STD_LOGIC;
           enableB : out STD_LOGIC;
           selA : out STD_LOGIC_VECTOR (1 downto 0);
           selB : out STD_LOGIC_VECTOR (1 downto 0);
           loadPC : out STD_LOGIC;
           selALU : out STD_LOGIC_VECTOR (2 downto 0);
           w : out STD_LOGIC;
           selAdd: out STD_LOGIC_VECTOR (1 downto 0);
           selDIn: out STD_LOGIC;
           selPC: out STD_LOGIC;
           incSP: out STD_LOGIC;
           decSp: out STD_LOGIC);
end ControlUnit;



architecture Behavioral of ControlUnit is


signal Opcode: std_logic_vector(6 downto 0);

signal Conditional: std_logic_vector(9 downto 0);

signal OUTPUT: std_logic_vector(16 downto 0);

constant LITA: std_logic_vector(1 downto 0) := "01";
constant ZERO: std_logic_vector(1 downto 0) := "00";
constant A: std_logic_vector(1 downto 0) := "11";
constant B: std_logic_vector(1 downto 0) := "01";
constant LIT: std_logic_vector(1 downto 0) := "11";
constant DOUT: std_logic_vector(1 downto 0) := "10";
constant ONE: std_logic_vector(1 downto 0) := "10";

constant ADD: std_logic_vector(2 downto 0) := "000";
constant SUB: std_logic_vector(2 downto 0) := "001";
constant AND1: std_logic_vector(2 downto 0) := "010";
constant OR1: std_logic_vector(2 downto 0) := "011";
constant NOTA: std_logic_vector(2 downto 0) := "101";
constant XOR1: std_logic_vector(2 downto 0) := "100";
constant SHLA: std_logic_vector(2 downto 0) := "111";
constant SHRA: std_logic_vector(2 downto 0) := "110";


constant ALU: std_logic := '0';
constant LITPC: std_logic := '1';
constant DOUTPC: std_logic := '0';
constant LIT1: std_logic_vector(1 downto 0) := "01";
constant B1: std_logic_vector(1 downto 0) := "10";
constant SP: std_logic_vector(1 downto 0) := "00";
constant PC: std_logic := '1';


begin

Opcode <= rom_dataout(6 downto 0);



Conditional <= Opcode & StaCU;

-- Conditional <= "0000000000";

loadPC <= OUTPUT(16);
enableA <= OUTPUT(15);
enableB <= OUTPUT(14);
selA <= OUTPUT(13 downto 12);
selB <= OUTPUT(11 downto 10);
selALU <= OUTPUT(9 downto 7);
w <= OUTPUT(6);
selAdd <= OUTPUT(5 downto 4);
selDIn <= OUTPUT(3);
selPC <= OUTPUT(2);
incSP <= OUTPUT(1);
decSP <= OUTPUT(0);

with Conditional select?
    OUTPUT <= "010" & ZERO & B & ADD & '0' & "--" & '-' & '-' & "00" when "0000000---",  -- 0
              "001" & A & ZERO & ADD & '0' & "--" & '-' & '-' & "00" when "0000001---",  -- 1
              "010" & ZERO & LIT & ADD & '0' & "--" & '-' & '-' & "00" when "0000010---", -- 2
              "001" & ZERO & LIT & ADD & '0' & "--" & '-' & '-' & "00" when "0000011---", -- 3
              "010" & ZERO & DOUT & ADD & '0' & LIT1 & '-' & '-' & "00" when "0000100---", -- 4
              "001" & ZERO & DOUT & ADD & '0' & LIT1 & '-' & '-' & "00" when "0000101---", -- 5
              "000" & A & ZERO & ADD & '1'& LIT1 & ALU & '-' & "00"  when "0000110---", -- 6
              "000" & ZERO & B & ADD & '1' & LIT1 & ALU & '-' & "00" when "0000111---", -- 7
              "010" & ZERO & DOUT & ADD & '0' & B1 & '-' & '-' & "00" when "0001000---", -- 8
              "001" & ZERO & DOUT & ADD & '0' & B1 & '-' & '-' & "00" when "0001001---",  -- 9
              "010" & A & ZERO & ADD & '1' & B1 & ALU & '-' & "00" when "0001010---",  -- 10
              "010" & A & B & ADD & '0' & "--" & '-' & '-' & "00" when "0001011---",  -- 11
              "001" & A & B & ADD & '0' & "--" & '-' & '-' & "00" when "0001100---",  -- 12
              "010" & A & LIT & ADD & '0' & "--" & '-' & '-' & "00" when "0001101---",  -- 13
              "010" & A & DOUT & ADD & '0' & LIT1 & '-' & '-' & "00" when "0001110---",  -- 14
              "010" & A & DOUT & ADD & '0' & B1 & '-' & '-' & "00" when "0001111---",  -- 15
              "000" & A & B & ADD & '1' & LIT1 & ALU & '-' & "00" when "0010000---",  -- 16
              "010" & A & B & SUB & '0' & "--" & '-' & '-' & "00" when "0010001---",  -- 17
              "001" & A & B & SUB & '0' & "--" & '-' & '-' & "00" when "0010010---",  -- 18
              "010" & A & LIT & SUB & '0' & "--" & '-' & '-' & "00" when "0010011---",  -- 19
              "010" & A & DOUT & SUB & '0' & LIT1 & '-' & '-' & "00" when "0010100---",  -- 20
              "010" & A & DOUT & SUB & '0' & B1 & '-' & '-' & "00" when "0010101---",  -- 21
              "000" & A & B & SUB & '1' & LIT1 & ALU & '-' & "00" when "0010110---",  -- 22
              "010" & A & B & AND1 & '0' & "--" & '-' & '-' & "00" when "0010111---",  -- 23
              "001" & A & B & AND1 & '0' & "--" & '-' & '-' & "00" when "0011000---",  -- 24
              "010" & A & LIT & AND1 & '0' & "--" & '-' & '-' & "00" when "0011001---",  -- 25
              "010" & A & DOUT & AND1 & '0' & LIT1 & '-' & '-' & "00" when "0011010---",  -- 26
              "010" & A & DOUT & AND1 & '0' & B1 & '-' & '-' & "00" when "0011011---",  -- 27
              "000" & A & B & AND1 & '1' & LIT1 & ALU & '-' & "00" when "0011100---",  -- 28
              "010" & A & B & OR1 & '0' & "--" & '-' & '-' & "00" when "0011101---",  -- 29
              "001" & A & B & OR1 & '0' & "--" & '-' & '-' & "00" when "0011110---",  -- 30
              "010" & A & LIT & OR1 & '0' & "--" & '-' & '-' & "00" when "0011111---",  -- 31
              "010" & A & DOUT & OR1 & '0' & LIT1 & '-' & '-' & "00" when "0100000---",  -- 32
              "010" & A & DOUT & OR1 & '0' & B1 & '-' & '-' & "00" when "0100001---",  -- 33
              "000" & A & B & OR1 & '1' & LIT1 & ALU & '-' & "00" when "0100010---",  -- 34
              "010" & A & "--" & NOTA & '0' & "--" & '-' & '-' & "00" when "0100011---",  -- 35
              "001" & A & "--" & NOTA & '0' & "--" & '-' & '-' & "00" when "0100100---",  -- 36
              "000" & A & B & NOTA & '1' & LIT1 & ALU & '-' & "00" when "0100101---",  -- 37
              "010" & A & B & XOR1 & '0' & "--" & '-' & '-' & "00" when "0100110---",  -- 38
              "001" & A & B & XOR1 & '0' & "--" & '-' & '-' & "00" when "0100111---",  -- 39
              "010" & A & LIT & XOR1 & '0' & "--" & '-' & '-' & "00" when "0101000---",  -- 40
              "010" & A & DOUT & XOR1 & '0' & LIT1 & '-' & '-' & "00" when "0101001---",  -- 41
              "010" & A & DOUT & XOR1 & '0' & B1 & '-' & '-' & "00" when "0101010---",  -- 42
              "000" & A & B & XOR1 & '1' & LIT1 & ALU & '-' & "00" when "0101011---",  -- 43
              "010" & A & "--" & SHLA & '0' & "--" & '-' & '-' & "00" when "0101100---",  -- 44
              "001" & A & "--" & SHLA & '0' & "--" & '-' & '-' & "00" when "0101101---",  -- 45
              "000" & A & B & SHLA & '1' & LIT1 & ALU & '-' & "00" when "0101110---",  -- 46
              "010" & A & "--" & SHRA & '0' & "--" & '-' & '-' & "00" when "0101111---",  -- 47
              "001" & A & "--" & SHRA & '0' & "--" & '-' & '-' & "00" when "0110000---",  -- 48
              "000" & A & B & SHRA & '1' & LIT1 & ALU & '-' & "00" when "0110001---",  -- 49
              "001" & ONE & B & ADD & '0' & "--" & '-' & '-' & "00" when "0110010---",  -- 50
              "000" & A & B & SUB & '0' & "--" & '-' & '-' & "00" when "0110011---",  -- 51
              "000" & A & LIT & SUB & '0' & "--" & '-' & '-' & "00" when "0110100---",  -- 52
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00" when "0110101---",  -- 53
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00" when "0110110-1-",  -- 54
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00" when "0110111-0-",  -- 55
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "0111000-00", -- 56
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "0111001--1", -- 57
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "0111010--0", -- 58
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "0111011-10", -- 59 V1
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "0111011-01", -- 59 V2
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "0111011-11", -- 59 V3
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "01111001--", -- 60
              "100" & "--" & "--" & "---" & '0' & "--" & '-' & LITPC & "00"  when "0111101---", -- 61
              "100" & "--" & "--" & "---" & '1' & SP & PC & LITPC & "01"  when "0111110---", -- 62
              "000" & "--" & "--" & "---" & '0' & "--" & '-' & '-' & "10"  when "0111111---", -- 63
              "100" & "--" & "--" & "---" & '0' & SP & '-' & '0' & "00"  when "1000000---", -- 64
              "000" & A & ZERO & ADD & '1' & SP & ALU & '-' & "01"  when "1000001---", -- 65
              "000" & ZERO & B & ADD & '1' & SP & ALU & '-' & "01"  when "1000010---", -- 66
              "000" & "--" & "--" & "---" & '0' & "--" & '-' & '-' & "10"  when "1000011---", -- 67
              "010" & ZERO & DOUT & ADD & '0' & SP & ALU & '-' & "00"  when "1000100---", -- 68
              "000" & "--" & "--" & "---" & '0' & "--" & '-' & '-' & "10"  when "1000101---", -- 69
              "001" & ZERO & DOUT & ADD & '0' & SP & ALU & '-' & "00"  when "1000110---", -- 70 
              "000" & A & ZERO & NOTA & '1' & LIT1 & ALU & '-' & "00"  when "1000111---", -- 71
              "000" & ONE & B & ADD & '1' & B1 & ALU & '-' & "00"  when "1001000---", -- 72
              "000" & ONE & DOUT & ADD & '1' & LIT1 & ALU & '-' & "00"  when "1001001---", -- 73
              "000" & A & DOUT & SUB & '0' & LIT1 & '-' & '-' & "00"  when "1001010---", -- 74 
              "000" & A & "--" & SHRA & '1' & LIT1 & ALU & '-' & "00"  when "1001011---", -- 75
              "000" & A & "--" & SHLA & '1' & LIT1 & ALU & '-' & "00"  when "1001100---", -- 76
              "001" & A & LIT & ADD & '0' & "--" & '-' & '-' & "00"  when "1001101---", -- 77  
              "001" & A & LIT & SUB & '0' & "--" & '-' & '-' & "00"  when "1001110---", -- 78
              "001" & A & LIT & AND1 & '0' & "--" & '-' & '-' & "00"  when "1001111---", -- 79
              "001" & A & LIT & XOR1 & '0' & "--" & '-' & '-' & "00"  when "1010000---", -- 80
              "000" & A & DOUT & SUB & '0' & B1 & '-' & '-' & "00"  when "1010001---", -- 81
              "000" & ZERO & LIT & ADD & '1' & B1 & ALU & '-' & "00"  when "1010010---", -- 82
              "001" & A & DOUT & ADD & '0' & B1 & '-' & '-' & "00"  when "1010011---", -- 83
              "001" & A & DOUT & SUB & '0' & B1 & '-' & '-' & "00"  when "1010100---", -- 84
              "001" & A & DOUT & AND1 & '0' & B1 & '-' & '-' & "00"  when "1010101---", -- 85
              "001" & A & DOUT & XOR1 & '0' & B1 & '-' & '-' & "00"  when "1010110---", -- 86
              "000" & A & B & NOTA & '1' & B1 & ALU & '-' & "00"  when "1010111---", -- 87
              "000" & A & B & SHLA & '1' & B1 & ALU & '-' & "00"  when "1011000---", -- 88
              "000" & A & B & SHRA & '1' & B1 & ALU & '-' & "00"  when "1011001---", -- 89
              "001" & A & LIT & OR1 & '0' & "--" & '-' & '-' & "00"  when "1011010---", -- 90
              "001" & A & DOUT & OR1 & '0' & B1 & '-' & '-' & "00"  when "1011011---", -- 91
              "001" & A & DOUT & ADD & '0' & LIT1 & '-' & '-' & "00"  when "1011100---", -- 92
              "001" & A & DOUT & SUB & '0' & LIT1 & '-' & '-' & "00"  when "1011101---", -- 93
              "001" & A & DOUT & AND1 & '0' & LIT1 & '-' & '-' & "00"  when "1011110---", -- 94
              "001" & A & DOUT & OR1 & '0' & LIT1 & '-' & '-' & "00"  when "1011111---", -- 95
              "001" & A & DOUT & XOR1 & '0' & LIT1 & '-' & '-' & "00"  when "1100000---", -- 96        
              "00000000000000000" when others;

end Behavioral;
