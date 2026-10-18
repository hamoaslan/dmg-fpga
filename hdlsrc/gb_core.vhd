----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2026 12:02:10 PM
-- Design Name: 
-- Module Name: gb_core - Behavioral
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

entity gb_core is
    Port (
        CLK_SYS : in std_logic;
        CLK_GB : in std_logic
        );
end gb_core;

architecture Behavioral of gb_core is

-- Memory
type w_ram is array (0 to 8191) of std_logic_vector (7 downto 0);
type v_ram is array (0 to 8191) of std_logic_vector (7 downto 0);
type echo_ram is array (0 to 7679) of std_logic_vector (7 downto 0);
type oam_mem is array (0 to 159) of std_logic_vector (7 downto 0);
type not_usable_mem is array (0 to 95) of std_logic_vector (7 downto 0);
type io_reg is array (0 to 127) of std_logic_vector (7 downto 0);
type h_ram is array (0 to 127) of std_logic_vector (7 downto 0);

begin

end Behavioral;
