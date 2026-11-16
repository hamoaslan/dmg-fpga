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

-- IR(xxyy yzzz) / IR(00pp q000)
alias op_x : std_logic_vector(1 downto 0) is reg_IR(7 downto 6);
alias op_y : std_logic_vector(2 downto 0) is reg_IR(5 downto 3);
alias op_z : std_logic_vector(2 downto 0) is reg_IR(2 downto 0);
alias op_p : std_logic_vector(1 downto 0) is reg_IR(5 downto 4);
alias op_q : std_logic is reg_IR(3);
    
begin

process (reg_IR, cb_prefix)
begin
    PATTERN <= P_ILLEGAL;
    if cb_prefix = '1' then
        null;
    else
        case op_x is
            when "00" =>
                case op_z is
                    when "000" => 
                        case op_y is
                            when "000" => PATTERN <= P_NOP;
                            when "001" => PATTERN <= P_LD_NN_SP;
                            when "010" => PATTERN <= P_STOP;
                            when others => PATTERN <= P_JR;
                        end case;
                    when "001" => 
                        if op_q = '0' then PATTERN <= P_LD_RR_NN;
                        else PATTERN <= P_ADD_HL_RR;
                        end if;
                    when "010" => 
                        if op_q = '0' then PATTERN <= P_LD_RR_A;
                        else PATTERN <= P_LD_A_RR;
                        end if;
                    when "011" => PATTERN <= P_INC_DEC_RR;
                    when "100" => 
                        if op_y = "110" then PATTERN <= P_INC_DEC_HL;
                        else PATTERN <= P_INC_R;
                        end if;
                    when "101" => 
                        if op_y = "110" then PATTERN <= P_INC_DEC_HL;
                        else PATTERN <= P_DEC_R;
                        end if;
                    when "110" => 
                        if op_y = "110" then PATTERN <= P_LD_HL_N;
                        else PATTERN <= P_LD_R_N;
                        end if;
                    when "111" => PATTERN <= P_ACC_MISC;
                    when others => null;
                end case;

            when "01" => 
                if op_y = "110" then
                    if op_z = "110" then PATTERN <= P_HALT;
                    else PATTERN <= P_LD_HL_R;
                    end if;
                else 
                    if op_z = "110" then PATTERN <= P_LD_R_HL;
                    else PATTERN <= P_LD_R_R; 
                    end if;
                end if;           
            when "10" => 
                if op_z = "110" then PATTERN <= P_ALU_HL;
                else PATTERN <= P_ALU_R;
                end if;
            when "11" => 

                case reg_IR is
                    when x"D3" | x"DB" | x"DD" | x"E3" | x"E4" | x"EB" | x"EC" | x"ED" | x"F4" | x"FC" | x"FD" => PATTERN <= P_ILLEGAL;
                    when x"E0" => PATTERN <= P_LDH_N_A;
                    when x"F0" => PATTERN <= P_LDH_A_N;
                    when x"E2" => PATTERN <= P_LDH_C_A;
                    when x"F2" => PATTERN <= P_LDH_A_C;
                    when x"EA" => PATTERN <= P_LD_NN_A;
                    when x"FA" => PATTERN <= P_LD_A_NN;
                    when x"F3" => PATTERN <= P_DI;
                    when x"FB" => PATTERN <= P_EI;
                    when x"CB" => PATTERN <= P_CB;
                    when x"C9" | x"D9" => PATTERN <= P_RET;
                    when x"E9" => PATTERN <= P_JP_HL;
                    when x"F9" => PATTERN <= P_LD_SP_HL;
                    when x"E8" => PATTERN <= P_ADD_SP_E;
                    when x"F8" => PATTERN <= P_LD_HL_SPE;
                    when x"C3" => PATTERN <= P_JP;
                    when x"CD" => PATTERN <= P_CALL;
                    when others =>
                        case op_z is
                            when "000" =>
                                if op_y(2) = '0' then PATTERN <= P_RET_CC;
                                end if;
                            when "001" =>
                                if op_q = '0' then PATTERN <= P_POP;
                                end if;
                            when "010" =>
                                if op_y(2) = '0' then PATTERN <= P_JP;
                                end if;
                            when "100" =>
                                if op_y(2) = '0' then PATTERN <= P_CALL;
                                end if;
                            when "101" =>
                                if op_q = '0' then PATTERN <= P_PUSH;
                                end if;
                            when "110" => PATTERN <= P_ALU_N;
                            when "111" => PATTERN <= P_RST;
                            when others => null;
                        end case;
                end case;
            when others => null;
        end case;
    end if;
end process;


end Behavioral;
