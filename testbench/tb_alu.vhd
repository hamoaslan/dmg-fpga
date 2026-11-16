----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2026 11:29:32 AM
-- Design Name: 
-- Module Name: tb_alu - Behavioral
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

entity tb_alu is
--  Port ( );
end tb_alu;

architecture Behavioral of tb_alu is

component alu
    port (
        data_in1 : in std_logic_vector(7 downto 0);
        data_in2 : in std_logic_vector(7 downto 0);
        op : in alu_op_type;
        bit_sel : in std_logic_vector(2 downto 0); 
        flags_in : in std_logic_vector(3 downto 0);
        data_out : out std_logic_vector(7 downto 0);
        flags_out : out std_logic_vector(3 downto 0)   
    );
end component;

signal alu_data_in1 : std_logic_vector(7 downto 0) := (others => '0');
signal alu_data_in2 : std_logic_vector(7 downto 0) := (others => '0');
signal alu_op : alu_op_type := ALU_NOP;
signal alu_bit_sel : std_logic_vector(2 downto 0) := (others => '0');
signal alu_flags_in : std_logic_vector(3 downto 0) := (others => '0');
signal alu_data_out : std_logic_vector(7 downto 0) := (others => '0');
signal alu_flags_out : std_logic_vector(3 downto 0) := (others => '0');

begin

dut : alu
port map(
    data_in1 => alu_data_in1,
    data_in2 => alu_data_in2,
    op => alu_op,
    bit_sel => alu_bit_sel,
    flags_in => alu_flags_in,
    flags_out => alu_flags_out,
    data_out => alu_data_out
);

process
begin
    wait for 1 ns;
    alu_op <= ALU_NOP;
    alu_data_in1 <= (others => '0'); 
    alu_data_in2 <= (others => '0'); 
    alu_flags_in <= (others => '0'); 
    
    -- expecting: 03, (0000)
    wait for 20 ns;
    alu_op <= ALU_ADD;
    alu_data_in1 <= x"01"; 
    alu_data_in2 <= x"02";
    alu_flags_in <= x"0";
    -- expecting: 00, (1011)
    wait for 20 ns;
    alu_op <= ALU_ADD;
    alu_data_in1 <= x"FF";
    alu_data_in2 <= x"01";
    alu_flags_in <= x"0";
    -- expecting: 10, (0010)
    wait for 20 ns;
    alu_op <= ALU_ADD;
    alu_data_in1 <= x"0F";
    alu_data_in2 <= x"01";
    alu_flags_in <= x"0";
    -- expecting: 00, (1011)
    wait for 20 ns;
    alu_op <= ALU_ADC;
    alu_data_in1 <= x"FF";
    alu_data_in2 <= x"00";
    alu_flags_in <= x"1";
    -- expecting: 03, (0000)
    wait for 20 ns;
    alu_op <= ALU_ADC;
    alu_data_in1 <= x"01"; 
    alu_data_in2 <= x"02";
    alu_flags_in <= x"0";
    -- expecting: 04, (0000)
    wait for 20 ns;
    alu_op <= ALU_ADC;
    alu_data_in1 <= x"01"; 
    alu_data_in2 <= x"02";
    alu_flags_in <= x"1";
    
    -- expecting: 03, (0100)
    wait for 20 ns;
    alu_op <= ALU_SUB;
    alu_data_in1 <= x"08"; 
    alu_data_in2 <= x"05";
    alu_flags_in <= x"0";
    -- expecting: FD, (0111)
    wait for 20 ns;
    alu_op <= ALU_SUB;
    alu_data_in1 <= x"05"; 
    alu_data_in2 <= x"08";
    alu_flags_in <= x"0";
    -- expecting: 2B, (0110)
    wait for 20 ns;
    alu_op <= ALU_SUB;
    alu_data_in1 <= x"3A";
    alu_data_in2 <= x"0F";
    alu_flags_in <= x"0";
    -- expecting: 03, (0100)
    wait for 20 ns;
    alu_op <= ALU_SBC;
    alu_data_in1 <= x"08"; 
    alu_data_in2 <= x"05";
    alu_flags_in <= x"0";
    -- expecting: 02, (0100)
    wait for 20 ns;
    alu_op <= ALU_SBC;
    alu_data_in1 <= x"08"; 
    alu_data_in2 <= x"05";
    alu_flags_in <= x"1";
    -- expecting: FF, (0111)
    wait for 20 ns;
    alu_op <= ALU_SBC;
    alu_data_in1 <= x"00";
    alu_data_in2 <= x"00";
    alu_flags_in <= x"1";
    
    -- expecting: 04, (0100)
    wait for 20 ns;
    alu_op <= ALU_CP;
    alu_data_in1 <= x"04"; 
    alu_data_in2 <= x"03";
    alu_flags_in <= x"0";
    -- expecting: 42, (1100)
    wait for 20 ns;
    alu_op <= ALU_CP;
    alu_data_in1 <= x"42";
    alu_data_in2 <= x"42";
    alu_flags_in <= x"0";
    
    -- expecting: B2, (0010)
    wait for 20 ns;
    alu_op <= ALU_AND;
    alu_data_in1 <= x"FA"; 
    alu_data_in2 <= x"B3";
    alu_flags_in <= x"0";
    -- expecting: FB, (0000)
    wait for 20 ns;
    alu_op <= ALU_OR;
    alu_data_in1 <= x"FA"; 
    alu_data_in2 <= x"B3";
    alu_flags_in <= x"0";
    -- expecting: 49, (0000)
    wait for 20 ns;
    alu_op <= ALU_XOR;
    alu_data_in1 <= x"FA"; 
    alu_data_in2 <= x"B3";
    alu_flags_in <= x"0";
    -- expecting: 00, (1000)
    wait for 20 ns;
    alu_op <= ALU_XOR;
    alu_data_in1 <= x"5A";
    alu_data_in2 <= x"5A";
    alu_flags_in <= x"0";

    wait for 20 ns;
    alu_op <= ALU_NOP;
    alu_data_in1 <= (others => '0'); 
    alu_data_in2 <= (others => '0'); 
    alu_flags_in <= (others => '0');
    wait;

end process;

end Behavioral;