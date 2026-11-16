----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2026 01:01:18 PM
-- Design Name: 
-- Module Name: tb_cpudecode - Behavioral
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

entity tb_cpudecode is
--  Port ( );
end tb_cpudecode;

architecture Behavioral of tb_cpudecode is

component cpu_decode
    port(
        reg_IR : in std_logic_vector(7 downto 0);
        cb_prefix : in  std_logic;
        PATTERN : out PATTERN_TYPE
    );    
end component;

signal reg_IR : std_logic_vector(7 downto 0) := (others => '0');
signal PATTERN : PATTERN_TYPE := P_NOP;
signal cb_prefix : std_logic := '0';

begin

dut : cpu_decode 
port map(
    reg_IR => reg_IR,
    cb_prefix => cb_prefix,
    PATTERN => PATTERN
);

process
begin
    for i in 0 to 255 loop
        reg_IR <= std_logic_vector(to_unsigned(i, 8));
        wait for 1 ns;
    end loop;
    wait;
end process;

end Behavioral;
