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

begin


end Behavioral;
