----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2026 07:04:02 PM
-- Design Name: 
-- Module Name: cpu - Behavioral
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

entity cpu is
    Port (
        CLK_SYS : in std_logic;
        CE_GB : in std_logic;
        RST : in std_logic;
        addr_bus: out std_logic_vector(15 downto 0);
        data_bus_in: in std_logic_vector(7 downto 0);
        data_bus_out: out std_logic_vector(7 downto 0);
        rd_en : out std_logic := '0';
        wr_en : out std_logic := '0'
        );
end cpu;

architecture Behavioral of cpu is

signal reg_IE: std_logic_vector(7 downto 0) := (others => '0');
signal reg_IR: std_logic_vector(7 downto 0) := (others => '0');

signal reg_A: std_logic_vector(7 downto 0) := (others => '0');
signal reg_F: std_logic_vector(7 downto 0) := (others => '0');
signal reg_B: std_logic_vector(7 downto 0) := (others => '0');
signal reg_C: std_logic_vector(7 downto 0) := (others => '0');
signal reg_D: std_logic_vector(7 downto 0) := (others => '0');
signal reg_E: std_logic_vector(7 downto 0) := (others => '0');
signal reg_H: std_logic_vector(7 downto 0) := (others => '0');
signal reg_L: std_logic_vector(7 downto 0) := (others => '0');

signal reg_SP: std_logic_vector(15 downto 0) := (others => '0');
signal reg_PC: std_logic_vector(15 downto 0) := (others => '0');

signal mcycle_count: unsigned(1 downto 0) := (others => '0');

type STATE_TYPE is (
    IDLE,
    INSTRUCTION_FETCH,
    INSTRUCTION_DECODE,
    FETCH_CYCLE
);
signal STATE, NEXT_STATE : STATE_TYPE;

type TASK_TYPE is (
    MISC,
    LOAD,
    LOAD16,
    ADD,
    ADD_CARRY,
    SUB,
    SUB_CARRY,
    LOGIC_OP,
    COMPARE,
    INC,
    DEC,
    ADD16,
    INC16,
    DEC16,
    JUMP,
    RESET,
    SHIFT
);
signal TASK, NEXT_TASK : TASK_TYPE;

begin

process (CLK_SYS)
begin
    if rising_edge(CLK_SYS) then
        if CE_GB = '1' then
            if RST='1' then
                reg_PC <= (others => '0');
                reg_SP <= (others => '0');
                
                reg_A <= (others => '0');
                reg_F <= (others => '0');
                reg_B <= (others => '0');
                reg_C <= (others => '0');
                reg_D <= (others => '0');
                reg_E <= (others => '0');
                reg_H <= (others => '0');
                reg_L <= (others => '0');
                
                reg_IR <= (others => '0');
                reg_IE <= (others => '0');
                
                mcycle_count <= (others => '0');
            else           
                case STATE is
                    when IDLE => STATE <= INSTRUCTION_FETCH;
                    when INSTRUCTION_FETCH => 
                        addr_bus <= reg_PC;
                        reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
                        STATE <= INSTRUCTION_DECODE;
                        
                    when others => null;
                end case;
                
                if mcycle_count < 3 then
                    mcycle_count <= mcycle_count + 1;
                else
                    mcycle_count <= (others => '0');
                end if;
            end if;
        end if;    
    end if;
end process;

end Behavioral;
