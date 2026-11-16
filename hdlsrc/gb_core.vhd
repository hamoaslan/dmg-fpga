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
        clock125 : in std_logic;
        reset_async : in std_logic
        );
end gb_core;

architecture Behavioral of gb_core is

-------------------------------------------
-- CLOCKING WIZARD
-------------------------------------------
component clk_wiz_0
    port
     (
        clk_out1          : out    std_logic;
        locked            : out    std_logic;
        clk_in1           : in     std_logic 
     );
end component;

signal CLK_SYS : std_logic;
signal RST_SYS : std_logic;
signal locked : std_logic;

-------------------------------------------
-- CPU
-------------------------------------------
component cpu
    port
    (
        CLK_SYS : in std_logic;
        CE_GB : in std_logic;
        RST : in std_logic;
        addr_bus : out std_logic_vector(15 downto 0);
        data_bus_in : in std_logic_vector(7 downto 0);
        data_bus_out : out std_logic_vector(7 downto 0);
        RD_EN : out std_logic := '0';
        WR_EN : out std_logic := '0'
        --mcycle_debug : out unsigned(1 downto 0) := (others => '0')
    );
end component;

signal CE_GB : std_logic := '0';
signal addr_bus : std_logic_vector(15 downto 0) := (others => '0');
signal data_bus_in : std_logic_vector(7 downto 0) := (others => '0');
signal data_bus_out : std_logic_vector(7 downto 0) := (others => '0');
signal RD_EN : std_logic := '0';
signal WR_EN : std_logic := '0';

signal ce_cnt : unsigned(3 downto 0) := (others => '0');

signal rst_raw : std_logic := '0';
-------------------------------------------
-- 
-------------------------------------------

begin
rst_raw <= reset_async or not locked;

my_clock : clk_wiz_0
    port map ( 
        clk_out1 => CLK_SYS,           
        locked => locked,
        clk_in1 => clock125
    );
 
 my_cpu : cpu
    port map (
        CLK_SYS => CLK_SYS,
        CE_GB => CE_GB,
        RST => RST_SYS,
        addr_bus => addr_bus,
        data_bus_in => data_bus_in,
        data_bus_out => data_bus_out,
        RD_EN => RD_EN,
        WR_EN => WR_EN
    );
 
 clock_enable_gb : process(CLK_SYS)
 begin
    if rising_edge(CLK_SYS) then
        if ce_cnt = 15 then
            ce_cnt <= (others => '0');
            CE_GB <= '1';
        else
            ce_cnt <= ce_cnt + 1;
            CE_GB <= '0';
        end if;
    end if;
 end process;
 
 sync_reset : entity work.meta_sync(RTL)
    port map(
        clock => CLK_SYS,
        async => rst_raw,
        sync => RST_SYS, 
        reset => '0'
    );

end Behavioral;
