--Binary 4 bit up down counter on FPGA (0 to 15 counter)

-- by Ninad Waingankar

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity updown4counter is
port( clk:in std_logic;	--12 MHz clock on FPGA
		status:in std_logic;	--up 1 down 0 counter status
		rst:in std_logic;	--reset
		decimal:out std_logic_vector(3 downto 0));	--8 bit updown counter output
end updown4counter;


-- developed by Ninad Waingankar

architecture updown of updown4counter is
	signal divider:std_logic_vector(23 downto 0);	--clock divider signal
	signal bin:std_logic_vector(3 downto 0):="0000";
		
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

	process(divider(23),rst)
		
	begin
		if(status='1') then	--up counter
			if(rst='1') then
				bin<="0000";
			
			elsif(rising_edge(divider(23))) then
				bin<=bin+'1';
				if(bin="1111") then
					bin<="0000";				
				end if;
			end if;
		else
			--down counter
			if(rst='1') then
				bin<="1111";
			
			elsif(rising_edge(divider(23))) then
				bin<=bin-'1';
				if(bin="0000") then
					bin<="1111";				
				end if;
			end if;
		end if;
	end process;
	decimal<=bin;
end updown;
