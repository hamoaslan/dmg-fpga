----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 03:43:33 PM
-- Design Name: 
-- Module Name: registerfile - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.gb_pkg.all;

entity registerfile is
    port(
        CLK_SYS : in std_logic;
        CE_GB : in std_logic;
        RST_SYS : in std_logic;
        RD_SEL : in std_logic_vector(2 downto 0);
        RD_DATA : out std_logic_vector(7 downto 0);
        WR_SEL : in std_logic_vector(2 downto 0);
        WR_DATA : in std_logic_vector(7 downto 0);
        WR_EN : in std_logic;
        A_OUT : out std_logic_vector(7 downto 0)
    );
end registerfile;

architecture Behavioral of registerfile is

signal reg_A: std_logic_vector(7 downto 0) := (others => '0');
signal reg_B: std_logic_vector(7 downto 0) := (others => '0');
signal reg_C: std_logic_vector(7 downto 0) := (others => '0');
signal reg_D: std_logic_vector(7 downto 0) := (others => '0');
signal reg_E: std_logic_vector(7 downto 0) := (others => '0');
signal reg_H: std_logic_vector(7 downto 0) := (others => '0');
signal reg_L: std_logic_vector(7 downto 0) := (others => '0');

begin

with RD_SEL select RD_DATA <=  
    reg_B when "000",
    reg_C when "001",
    reg_D when "010",
    reg_E when "011",
    reg_H when "100",
    reg_L when "101",
    reg_A when "111",
    x"00" when others;

A_OUT <= reg_A;

process (CLK_SYS)
begin
    if rising_edge(CLK_SYS) then
        if RST_SYS = '1' then
            reg_A <= x"00";
            reg_B <= x"00";
            reg_C <= x"00";
            reg_D <= x"00";
            reg_E <= x"00";
            reg_H <= x"00";
            reg_L <= x"00";
        elsif CE_GB = '1' then
            if WR_EN = '1' then
                case WR_SEL is
                    when "000" => reg_B <= WR_DATA;
                    when "001" => reg_C <= WR_DATA;
                    when "010" => reg_D <= WR_DATA;
                    when "011" => reg_E <= WR_DATA;
                    when "100" => reg_H <= WR_DATA;
                    when "101" => reg_L <= WR_DATA;
                    when "111" => reg_A <= WR_DATA;
                    when others => null;
                end case;
            end if;
        end if;
    end if;
end process;

end Behavioral;
