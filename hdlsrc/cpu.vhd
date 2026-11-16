
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
use work.gb_pkg.all;

entity cpu is
    Port (
        CLK_SYS : in std_logic;
        CE_GB : in std_logic;
        RST : in std_logic;
        addr_bus : out std_logic_vector(15 downto 0);
        data_bus_in : in std_logic_vector(7 downto 0);
        data_bus_out : out std_logic_vector(7 downto 0);
        RD_EN : out std_logic := '0';
        WR_EN : out std_logic := '0'
        );
end cpu;

architecture Behavioral of cpu is

-------------------------------------------
-- REGISTER FILE
-------------------------------------------
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

signal reg_Z: std_logic_vector(7 downto 0) := (others => '0');
signal reg_W: std_logic_vector(7 downto 0) := (others => '0');

-------------------------------------------
-- ALU
-------------------------------------------
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

-------------------------------------------
-- INSTRUTION DECODE
-------------------------------------------
component cpu_decode
    port(
        reg_IR : in std_logic_vector(7 downto 0);
        cb_prefix : in  std_logic;
        PATTERN : out PATTERN_TYPE
    );    
end component;

signal PATTERN : PATTERN_TYPE;
signal cb_prefix : std_logic := '0';

-- IR(xxyy yzzz) / IR(00pp q000)
alias op_x : std_logic_vector(1 downto 0) is reg_IR(7 downto 6);
alias op_y : std_logic_vector(2 downto 0) is reg_IR(5 downto 3);
alias op_z : std_logic_vector(2 downto 0) is reg_IR(2 downto 0);
alias op_p : std_logic_vector(1 downto 0) is reg_IR(5 downto 4);
alias op_q : std_logic is reg_IR(3);

-------------------------------------------
-- STATE MACHINE (FSM)
-------------------------------------------
signal m_cycle_count: unsigned(1 downto 0) := (others => '0');

type STATE_TYPE is (
    IDLE,
    FETCH,
    EXEC1,
    EXEC2,
    EXEC3,
    EXEC4,
    EXEC5,
    EXEC6
);
signal STATE : STATE_TYPE := IDLE;

-------------------------------------------
-- 
-------------------------------------------
signal do_fetch : std_logic := '0';

begin

my_alu : alu
    port map(
        data_in1 => alu_data_in1,
        data_in2 => alu_data_in2,
        op => alu_op,
        bit_sel => alu_bit_sel,
        flags_in => alu_flags_in,
        flags_out => alu_flags_out,
        data_out => alu_data_out
    );

my_cpu_decode : cpu_decode 
    port map(
        reg_IR => reg_IR,
        cb_prefix => cb_prefix,
        PATTERN => PATTERN
    );

fetch_proc : process (STATE, PATTERN)
begin
    do_fetch <= '0';
    case STATE is
        when FETCH => do_fetch <= '1';
        when EXEC1 => 
            case PATTERN is
                when P_NOP | P_LD_R_R => do_fetch <= '1';
                when others => null;
            end case;
        when EXEC2 =>
            case PATTERN is
                when P_LD_R_N => do_fetch <= '1';
                when others => null;
            end case;
        --when EXEC3 =>
        --when EXEC4 =>
        --when EXEC5 =>
        --when EXEC6 =>
        when others => null;
    end case;
end process fetch_proc;

process (CLK_SYS)
begin
    if rising_edge(CLK_SYS) then
        if RST = '1' then
            reg_PC <= (others => '0');
            reg_SP <= (others => '0');
            
            reg_A <= x"00";
            reg_F <= x"00";
            reg_B <= x"00";
            reg_C <= x"00";
            reg_D <= x"00";
            reg_E <= x"00";
            reg_H <= x"00";
            reg_L <= x"00";
            
            reg_IR <= (others => '0');
            reg_IE <= (others => '0');
            
            RD_EN <= '0';
            WR_EN <= '0';
            
            m_cycle_count <= (others => '0');
            
            STATE <= IDLE;    
        elsif CE_GB = '1' then
            RD_EN <= '0';
            WR_EN <= '0';
            
            case STATE is 
                when IDLE => 
                    if m_cycle_count = 3 then
                        STATE <= FETCH;
                    end if;    
                when FETCH => null;
                when EXEC1 =>
                    case PATTERN is
                        when P_NOP => null;
                        when P_LD_R_R => 
                            if m_cycle_count = 3 then
                                reg_B <= reg_A;
                            end if;
                        when P_LD_R_N => 
                            if m_cycle_count = 0 then    
                                RD_EN <= '1';
                                addr_bus <= reg_PC;
                                reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
                            elsif m_cycle_count = 3 then
                                reg_Z <= data_bus_in;
                                STATE <= EXEC2;
                            end if;
                        when others => NULL; 
                    end case;
                when EXEC2 =>
                    case PATTERN is
                        when P_LD_R_N => 
                            if m_cycle_count = 3 then
                                reg_A <= reg_Z;
                            end if;
                        when others => NULL; 
                    end case;
                when EXEC3 =>
                    case PATTERN is
                        when others => NULL; 
                    end case;
                when EXEC4 =>
                    case PATTERN is
                        when others => NULL; 
                    end case;
                when EXEC5 =>
                    case PATTERN is
                        when others => NULL; 
                    end case;
                when EXEC6 =>
                    case PATTERN is
                        when others => NULL; 
                    end case;
                    
                when others => STATE <= IDLE;
            end case;
            
            if do_fetch = '1' then
                if m_cycle_count = 0 then
                    RD_EN <= '1';
                    addr_bus <= reg_PC;
                    reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
                elsif m_cycle_count = 3 then
                    reg_IR <= data_bus_in;
                    STATE <= EXEC1;
                end if;   
            end if;

            m_cycle_count <= m_cycle_count + 1;
            
        end if;
    end if;
end process;

end Behavioral;