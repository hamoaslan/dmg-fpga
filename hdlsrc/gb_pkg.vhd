----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/03/2026 10:51:25 AM
-- Design Name: 
-- Module Name: gb_pkg - Behavioral
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

package gb_pkg is
    type alu_op_type is (
        ALU_ADD, ALU_ADC, 
        ALU_SUB, ALU_SBC,
        ALU_AND, ALU_OR, ALU_XOR, ALU_CP,
        ALU_NOP
    );
    
    type PATTERN_TYPE is (
    -- 8bit LOAD
    P_NOP,
    P_LD_R_R,
    P_LD_R_N,
    P_LD_R_HL,
    P_LD_HL_R,
    P_LD_HL_N,
    P_LD_RR_A,
    P_LD_A_RR,
    P_LDH_N_A,
    P_LDH_A_N,
    P_LDH_C_A,
    P_LDH_A_C,
    P_LD_NN_A,
    P_LD_A_NN,
    -- 8bit ALU
    P_ALU_R,
    P_ALU_HL,
    P_ALU_N,
    P_INC_R,
    P_DEC_R,
    P_INC_DEC_HL,
    P_ACC_MISC,
    --16bit
    P_LD_RR_NN,
    P_INC_DEC_RR,
    P_ADD_HL_RR,
    P_PUSH,
    P_POP,
    P_LD_SP_HL,
    P_LD_NN_SP,
    P_ADD_SP_E,
    P_LD_HL_SPE,
    -- JUMP
    P_JP,
    P_JR,
    P_CALL,
    P_RET,
    P_RET_CC,
    P_JP_HL,
    P_RST,
    -- MISC
    P_HALT,
    P_STOP,
    P_DI, 
    P_EI,
    P_CB,
    P_ILLEGAL
    --CB-PREFIX
);
end package gb_pkg;

