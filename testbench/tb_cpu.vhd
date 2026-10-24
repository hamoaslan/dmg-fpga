----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2026 08:18:02 PM
-- Design Name: 
-- Module Name: tb_cpu - Behavioral
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

entity tb_cpu is
    -- Port ();
end tb_cpu;

architecture Behavioral of tb_cpu is

component cpu is
    Port (
        CLK_SYS : in std_logic;
        CE_GB : in std_logic;
        RST : in std_logic;
        addr_bus : out std_logic_vector(15 downto 0);
        data_bus_in : in std_logic_vector(7 downto 0);
        data_bus_out : out std_logic_vector(7 downto 0);
        rd_en : out std_logic;
        wr_en : out std_logic;
        mcycle_debug : out unsigned(1 downto 0) := (others => '0')
        );
end component;

signal clk : std_logic := '0';
signal ce : std_logic := '0';
signal rst : std_logic := '0';
signal addr_bus : std_logic_vector(15 downto 0) := (others => '0');
signal data_bus_in : std_logic_vector(7 downto 0) := (others => '0');
signal data_bus_out : std_logic_vector(7 downto 0) := (others => '0');
signal rd_en : std_logic := '0';
signal wr_en : std_logic := '0';
signal mcycle_debug : unsigned(1 downto 0) := (others => '0');

constant CLK_PERIOD: time := 8 ns;
constant CE_DIV : natural := 30;
signal ce_cnt : natural range 0 to CE_DIV-1 := 0;

constant rom_depth : natural := 256;
constant rom_width : natural := 8;

type rom_type is array (0 to rom_depth - 1) of std_logic_vector(rom_width - 1 downto 0);

constant rom : rom_type :=(
    0 => x"40",
    1 => x"41",
    2 => x"42",
    3 => x"43",
    4 => x"44",
    5 => x"45",
    6 => x"47",
    7 => x"48",
    8 => x"49",
    9 => x"4A",
    10 => x"4B",
    11 => x"4C",
    12 => x"4D",
    13 => x"4F",
    others => x"00"
);

signal test1_done : std_logic := '0';
begin
    uut: cpu Port Map(
        CLK_SYS => clk,
        CE_GB => ce,
        RST => rst,
        addr_bus => addr_bus,
        data_bus_in => data_bus_in,
        data_bus_out => data_bus_out,
        rd_en => rd_en,
        wr_en => wr_en,
        mcycle_debug => mcycle_debug
    );
    

    clk <= not clk after CLK_PERIOD/2;
    
    data_bus_in <= rom(to_integer(unsigned(addr_bus(7 downto 0))));
    
    clock_enable : process(clk)
    begin
        if rising_edge(clk) then
            if ce_cnt = CE_DIV-1 then
                ce_cnt <= 0;
                ce <= '1';
            else
                ce_cnt <= ce_cnt + 1;
                ce <= '0';
            end if;
        end if;
    end process clock_enable;
    
    test_1 : process
    begin
        rst <= '1';
        wait until rising_edge(clk) and ce = '1';
        wait until rising_edge(clk) and ce = '1';
        rst <= '0';
        
        wait until addr_bus = x"000E";
        test1_done <= '1';
        wait;
    end process test_1;
    


end Behavioral;
