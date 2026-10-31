
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
        addr_bus : out std_logic_vector(15 downto 0);
        data_bus_in : in std_logic_vector(7 downto 0);
        data_bus_out : out std_logic_vector(7 downto 0);
        rd_en : out std_logic := '0';
        wr_en : out std_logic := '0';
        mcycle_debug : out unsigned(1 downto 0) := (others => '0')
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

-------------------------------------------
-- ALU
-------------------------------------------
component alu
    port (
        data_in1 : in std_logic;
        data_in2 : in std_logic;
        data_out : out std_logic        
    );
end component;

signal alu_data_in1 : std_logic := '0';
signal alu_data_in2 : std_logic := '0';
signal alu_data_out : std_logic := '0';
-------------------------------------------
-- CLOCKING WIZARD
-------------------------------------------

signal mcycle_count: unsigned(1 downto 0) := (others => '0');

type STATE_TYPE is (
    IDLE,
    FETCH,
    DECODE,
    EXECUTE,
    READBUS,
    WRITEBUS,
    WAIT_T_CYCLE,
    WAIT_M_CYCLE,
    FETCH_CYCLE
);
signal STATE : STATE_TYPE;

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
signal TASK : TASK_TYPE;

type REGISTER_TYPE is (
    r_A,
    r_F,
    r_B,
    r_C,
    r_D,
    r_E,
    r_H,
    r_L,
    r_SP,
    r_PC,
    r_IR,
    r_IE
);
signal target, source : REGISTER_TYPE;

begin
mcycle_debug <= mcycle_count;

my_alu : alu
    port map (
        data_in1 => alu_data_in1,
        data_in2 => alu_data_in2,
        data_out => alu_data_out
    );

process (CLK_SYS)
begin
    if rising_edge(CLK_SYS) then
        if CE_GB = '1' then
            if RST='1' then
                reg_PC <= (others => '0');
                reg_SP <= (others => '0');
                
                reg_A <= x"0A";
                reg_F <= x"0F";
                reg_B <= x"0B";
                reg_C <= x"0C";
                reg_D <= x"0D";
                reg_E <= x"0E";
                reg_H <= x"09";
                reg_L <= x"08";
                
                reg_IR <= (others => '0');
                reg_IE <= (others => '0');
                
                rd_en <= '0';
                wr_en <= '0';
                
                mcycle_count <= (others => '0');
                
                STATE <= IDLE;
            else       
                rd_en <= '0';
                wr_en <= '0';
                    
                case STATE is
                    when IDLE => STATE <= FETCH;
                    when FETCH => 
                        rd_en <= '1';
                        addr_bus <= reg_PC;
                        reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
                        STATE <= READBUS;                       
                    when READBUS =>
                        if mcycle_count = 0 then
                            reg_IR <= data_bus_in;
                            STATE <= DECODE;                        
                        else 
                            STATE <= WAIT_M_CYCLE;
                        end if;                   
                    when DECODE =>
                        case reg_IR is
                            when x"00" => 
                                STATE <= EXECUTE;
                            when x"40" | x"41" | x"42" | x"43" | x"44" | x"45" | x"47" =>
                                case reg_IR is
                                    when x"40" => reg_B <= reg_B;
                                    when x"41" => reg_B <= reg_C;
                                    when x"42" => reg_B <= reg_D;
                                    when x"43" => reg_B <= reg_E;
                                    when x"44" => reg_B <= reg_H;
                                    when x"45" => reg_B <= reg_L;
                                    when x"47" => reg_B <= reg_A;
                                    when others => NULL;
                                end case;
                                STATE <= EXECUTE;
                            when x"50" | x"51" | x"52" | x"53" | x"54" | x"55" | x"57" =>
                                case reg_IR is
                                    when x"50" => reg_D <= reg_B;
                                    when x"51" => reg_D <= reg_C;
                                    when x"52" => reg_D <= reg_D;
                                    when x"53" => reg_D <= reg_E;
                                    when x"54" => reg_D <= reg_H;
                                    when x"55" => reg_D <= reg_L;
                                    when x"57" => reg_D <= reg_A;
                                    when others => NULL;
                                end case;
                                STATE <= EXECUTE;
                            when x"60" | x"61" | x"62" | x"63" | x"64" | x"65" | x"67" =>
                                case reg_IR is
                                    when x"60" => reg_H <= reg_B;
                                    when x"61" => reg_H <= reg_C;
                                    when x"62" => reg_H <= reg_D;
                                    when x"63" => reg_H <= reg_E;
                                    when x"64" => reg_H <= reg_H;
                                    when x"65" => reg_H <= reg_L;
                                    when x"67" => reg_H <= reg_A;
                                    when others => NULL;
                                end case;
                                STATE <= EXECUTE;
---------------------------------------------------------------------------------------                                
                            when x"48" | x"49" | x"4A" | x"4B" | x"4C" | x"4D" | x"4F" =>
                                case reg_IR is
                                    when x"48" => reg_C <= reg_B;
                                    when x"49" => reg_C <= reg_C;
                                    when x"4A" => reg_C <= reg_D;
                                    when x"4B" => reg_C <= reg_E;
                                    when x"4C" => reg_C <= reg_H;
                                    when x"4D" => reg_C <= reg_L;
                                    when x"4F" => reg_C <= reg_A;
                                    when others => NULL;
                                end case;
                                STATE <= EXECUTE;
                            when x"58" | x"59" | x"5A" | x"5B" | x"5C" | x"5D" | x"5F" =>
                                case reg_IR is
                                    when x"58" => reg_E <= reg_B;
                                    when x"59" => reg_E <= reg_C;
                                    when x"5A" => reg_E <= reg_D;
                                    when x"5B" => reg_E <= reg_E;
                                    when x"5C" => reg_E <= reg_H;
                                    when x"5D" => reg_E <= reg_L;
                                    when x"5F" => reg_E <= reg_A;
                                    when others => NULL;
                                end case;
                                STATE <= EXECUTE;                             
                            when x"68" | x"69" | x"6A" | x"6B" | x"6C" | x"6D" | x"6F" =>
                                case reg_IR is
                                    when x"68" => reg_L <= reg_B;
                                    when x"69" => reg_L <= reg_C;
                                    when x"6A" => reg_L <= reg_D;
                                    when x"6B" => reg_L <= reg_E;
                                    when x"6C" => reg_L <= reg_H;
                                    when x"6D" => reg_L <= reg_L;
                                    when x"6F" => reg_L <= reg_A;
                                    when others => NULL;
                                end case;
                                STATE <= EXECUTE;
                            when others => STATE <= IDLE;                        
                        end case;
                    when EXECUTE => 
                        case TASK is
                            when LOAD => target <= source; 
                            when others => NULL;
                        end case;
                        rd_en <= '1';
                        addr_bus <= reg_PC;
                        reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
                        STATE <= WAIT_M_CYCLE;
                    when WAIT_M_CYCLE =>
                        if mcycle_count = 3 then
                            STATE <= READBUS;
                        end if;
                    when others => STATE <= IDLE;
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
