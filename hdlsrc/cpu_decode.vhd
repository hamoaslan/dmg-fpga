----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2026 12:47:53 PM
-- Design Name: 
-- Module Name: cpu_decode - Behavioral
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

entity cpu_decode is
    port ( 
        reg_IR : in std_logic_vector(7 downto 0);
        cb_prefix : in  std_logic;
        PATTERN : out PATTERN_TYPE
    );
end cpu_decode;

architecture Behavioral of cpu_decode is

alias op_x : std_logic_vector(1 downto 0) is reg_IR(7 downto 6);
alias op_y : std_logic_vector(2 downto 0) is reg_IR(5 downto 3);
alias op_z : std_logic_vector(2 downto 0) is reg_IR(2 downto 0);
alias op_p : std_logic_vector(1 downto 0) is reg_IR(5 downto 4);
alias op_q : std_logic is reg_IR(3);
    
begin

process (reg_IR, cb_prefix)
begin
    if cb_prefix = '1' then
        null;
    else
        PATTERN <= P_ILLEGAL;
        case op_x is
            when "00" =>
                if reg_IR = x"00" then PATTERN <= P_NOP;
                elsif reg_IR = x"10" then PATTERN <= P_STOP;
                elsif reg_IR(7 downto 1) = "0011010" then PATTERN <= P_INC_DEC_HL;
                elsif reg_IR = x"08" then PATTERN <= P_LD_NN_SP;

                elsif op_z = "110" and op_y = "110" then Pattern <= P_LD_HL_N;
                elsif op_z = "110" then PATTERN <= P_LD_R_N;
                elsif op_z = "010" and op_q = '0' then PATTERN <= P_LD_RR_A;
                elsif op_z = "010" and op_q = '1' then PATTERN <= P_LD_A_RR;
                
                elsif op_z = "100" then PATTERN <= P_INC_R;
                elsif op_z = "101" then PATTERN <= P_DEC_R;
                elsif op_z = "111" then PATTERN <= P_ACC_MISC;
                
                elsif op_z = "001" and op_q = '0' then PATTERN <= P_LD_RR_NN;
                elsif op_z = "001" and op_q = '1' then PATTERN <= P_ADD_HL_RR;
                elsif op_z = "011" then PATTERN <= P_INC_DEC_RR;

                elsif op_z = "000" and (op_y(2) = '1' or op_y = "011") then PATTERN <= P_JR;
                end if;
            when "01" => 
                if reg_IR = x"76" then PATTERN <= P_HALT;
                elsif op_y = "110" then PATTERN <= P_LD_HL_R;
                elsif op_z = "110" then PATTERN <= P_LD_R_HL;
                else PATTERN <= P_LD_R_R;
                end if;
            when "10" => 
                if op_z = "110" then PATTERN <= P_ALU_HL;
                else PATTERN <= P_ALU_R;
                end if;
            when "11" => 
                if reg_IR = x"D3" or reg_IR = x"DB" or reg_IR = x"DD" or reg_IR = x"E3" or reg_IR = x"E4" or reg_IR = x"EB" or reg_IR = x"EC" or reg_IR = x"ED" or reg_IR = x"F4" or reg_IR = x"FC" or reg_IR = x"FD"  then PATTERN <= P_ILLEGAL;
                elsif reg_IR = x"E0"  then PATTERN <= P_LDH_N_A;
                elsif reg_IR = x"F0"  then PATTERN <= P_LDH_A_N;

                elsif reg_IR = x"E2"  then PATTERN <= P_LDH_C_A;
                elsif reg_IR = x"F2"  then PATTERN <= P_LDH_A_C;
                
                elsif reg_IR = x"EA"  then PATTERN <= P_LD_NN_A;
                elsif reg_IR = x"FA"  then PATTERN <= P_LD_A_NN;
                
                elsif reg_IR = x"F3"  then PATTERN <= P_DI;
                elsif reg_IR = x"FB"  then PATTERN <= P_EI;
                elsif reg_IR = x"CB"  then PATTERN <= P_CB;
                    
                elsif reg_IR = x"C9" or reg_IR = x"D9" then PATTERN <= P_RET;    
                elsif reg_IR = x"E9"  then PATTERN <= P_JP_HL;

                elsif reg_IR = x"F9" then PATTERN <= P_LD_SP_HL;
                elsif reg_IR = x"E8" then PATTERN <= P_ADD_SP_E;
                elsif reg_IR = x"F8" then PATTERN <= P_LD_HL_SPE;
                    
                elsif op_z = "110" then PATTERN <= P_ALU_N;
                elsif op_z = "101" and op_q = '0' then PATTERN <= P_PUSH;
                elsif op_z = "001" and op_q = '0' then PATTERN <= P_POP;

                elsif (op_z = "010" and op_y(2) = '0') or reg_IR = x"C3" then PATTERN <= P_JP;
                elsif (op_z = "100" and op_y(2) = '0') or reg_IR = x"CD" then PATTERN <= P_CALL;
                elsif op_z = "000" and op_y(2) = '0' then PATTERN <= P_RET_CC;
                elsif op_z = "111" then PATTERN <= P_RST;
                end if;
            when others => null;
        end case;
    end if;
end process;


end Behavioral;
