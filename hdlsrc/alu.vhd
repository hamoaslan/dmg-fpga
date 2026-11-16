----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2026 04:20:13 PM
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
    port(
       data_in1 : in std_logic_vector(7 downto 0);
       data_in2 : in std_logic_vector(7 downto 0);
       op : in alu_op_type;
       bit_sel : in std_logic_vector(2 downto 0); 
       flags_in : in std_logic_vector(3 downto 0);
       data_out : out std_logic_vector(7 downto 0);
       flags_out : out std_logic_vector(3 downto 0)
    );
end alu;

architecture Behavioral of alu is

signal SUM : unsigned(8 downto 0);
signal OPERAND_B : std_logic_vector(7 downto 0);
signal CIN : std_logic;
signal IS_SUB : std_logic;
signal HSUM : unsigned(4 downto 0);
signal LOGIC_RESULT : std_logic_vector(7 downto 0);

begin

-- Arithmetic operations:
with op select CIN <=
    '1'             when ALU_SUB | ALU_CP,
    flags_in(0)     when ALU_ADC,
    not flags_in(0) when ALU_SBC,
    '0'             when others;

IS_SUB <= '1' when op = ALU_SUB or op = ALU_SBC or op = ALU_CP else '0';
OPERAND_B <= not data_in2 when IS_SUB = '1' else data_in2;

SUM <= unsigned('0' & data_in1) + unsigned('0' & OPERAND_B) + unsigned'("00000000" & CIN);            
HSUM <= unsigned('0' & data_in1(3 downto 0)) + unsigned('0' & OPERAND_B(3 downto 0)) + unsigned'("0000" & CIN);

-- Logic operations:
with op select LOGIC_RESULT <=
    data_in1 and data_in2 when ALU_AND,
    data_in1 or data_in2 when ALU_OR,
    data_in1 xor data_in2 when others;

process (op, data_in1, flags_in, SUM, IS_SUB, HSUM, LOGIC_RESULT) 
begin
    data_out <= data_in1;
    flags_out <= flags_in;

    case op is
        when ALU_ADD | ALU_ADC | ALU_SUB | ALU_SBC | ALU_CP => 
            if op /= ALU_CP then
                data_out <= std_logic_vector(SUM(7 downto 0));
            end if;
            -- SET FLAGS
            if SUM(7 downto 0) = 0 then
                flags_out(3) <= '1';            -- z-flag
            else 
                flags_out(3) <= '0';
            end if;
            flags_out(2) <= IS_SUB;             -- n-flag
            flags_out(1) <= HSUM(4) xor IS_SUB; -- h-flag
            flags_out(0) <= SUM(8) xor IS_SUB;  -- c-flag

        when ALU_AND | ALU_OR | ALU_XOR => 
            data_out <= LOGIC_RESULT;
            if LOGIC_RESULT = x"00" then 
                flags_out(3) <= '1'; 
            else
                flags_out(3) <= '0'; 
            end if;
            
            flags_out(2) <= '0';
            
            if op = ALU_AND then 
                flags_out(1) <= '1'; 
            else
                flags_out(1) <= '0'; 
            end if;
            
            flags_out(0) <= '0';

        when others => null;
    end case;
end process;

end Behavioral;