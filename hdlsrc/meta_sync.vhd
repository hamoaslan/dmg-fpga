----------------------------------------------------------------------------------
-- Module Name: meta_sync - Behavioral
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity meta_sync is
	Port(
		clock : in STD_LOGIC;
		async : in STD_LOGIC;
		sync  : out STD_LOGIC;
		reset : in STD_LOGIC
		);
end meta_sync;

architecture RTL of meta_sync is

	signal stage1, stage2: std_logic := '0'; -- at configuration time 0 without reset

	attribute ASYNC_REG : string;
	attribute ASYNC_REG of stage1 : signal is "TRUE";
	attribute ASYNC_REG of stage2 : signal is "TRUE";

begin

	sync <= stage2;

	process(clock)
	begin
		if (rising_edge(clock)) then
			if (reset='1') then
				stage2 <= '0';
				stage1 <= '0';
			else
				stage2 <= stage1;
				stage1 <= async;
			end if;
		end if;
	end process;

end RTL;
