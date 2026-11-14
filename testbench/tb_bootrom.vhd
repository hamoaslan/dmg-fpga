----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2026 09:53:45 AM
-- Design Name: 
-- Module Name: tb_bootrom - Behavioral
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
use std.textio.all;

entity tb_bootrom is
--    PORT(
--        SYS_CLK : in std_logic;
--        addr_bus: in std_logic_vector(15 downto 0);
--        data_bus_out: out std_logic_vector(7 downto 0)
--    );
end tb_bootrom;

architecture Behavioral of tb_bootrom is
constant rom_depth : natural := 256;
constant rom_width : natural := 8;

type rom_type is array (0 to rom_depth - 1) of std_logic_vector(rom_width - 1 downto 0);

impure function init_rom_bin return rom_type is
    type binary_file is file of character;
    file rom_file : binary_file open read_mode is
        "/home/h53/bachelorarbeit/gb-bootroms/bin/dmg.bin";

    variable byte_value  : character;
    variable rom_content : rom_type;
begin
    for i in 0 to rom_depth - 1 loop
        read(rom_file, byte_value);

        rom_content(i) := std_logic_vector(
            to_unsigned(character'pos(byte_value), rom_width)
        );
    end loop;

    return rom_content;
end function;

signal bootrom : rom_type;

signal clk : std_logic := '0';
signal clk_period : time := 1 ms;
signal read_en : std_logic := '0';
signal read_rom_byte : std_logic_vector(rom_width-1 downto 0) := (others => '0');
signal read_addr : unsigned(rom_width-1 downto 0) := (others => '0');
signal count : unsigned(rom_width-1 downto 0) := (others => '0');

begin

clk_process : process
begin
    clk <= not clk;
    wait for clk_period;
    
end process;

load_rom : process
begin
    wait for 1 ms;
    bootrom <= init_rom_bin;
    read_en <= '1';
    wait;
end process;

process (clk)
begin
    if rising_edge(clk) then
        if read_en = '1' and count < rom_depth then
            read_rom_byte <= bootrom(to_integer(count));
            read_addr <= count;
            count <= count + 1;
        end if;    
    end if;
    
end process;

end Behavioral;
