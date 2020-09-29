--Binary 8 bit up down counter on FPGA (0 to 255 counter)

-- by Ninad Waingankar

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity updown8counter is
port( clk:in std_logic;	--12 MHz clock on FPGA
		status:in std_logic;	--up 1 down 0 counter status
		rst:in std_logic;	--reset
		decimal:out std_logic_vector(7 downto 0));	--8 bit updown counter output
end updown8counter;


-- developed by Ninad Waingankar

architecture updown of updown8counter is
	signal divider:std_logic_vector(19 downto 0);	--clock divider signal
	signal bin:std_logic_vector(7 downto 0):="00000000";
		
begin
	process(clk,rst) 
	begin
		if(rst='1') then
			divider<=(others=>'0');
		elsif(rising_edge(clk)) then
			divider<=divider+'1';
		end if;
	end process;
	--developed by Ninad Waingankar

	process(divider(19),rst)
		
	begin
		if(status='1') then	--up counter
			if(rst='1') then
				bin<="00000000";
			
			elsif(rising_edge(divider(19))) then
				bin<=bin+'1';
				if(bin="11111111") then
					bin<="00000000";				
				end if;
			end if;
		else
			--down counter
			if(rst='1') then
				bin<="11111111";
			
			elsif(rising_edge(divider(19))) then
				bin<=bin-'1';
				if(bin="00000000") then
					bin<="11111111";				
				end if;
			end if;
		end if;
	end process;
	decimal<=bin;
end updown;
