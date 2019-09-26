--code provided at http://www.deathbylogic.com/2013/07/vhdl-standard-fifo/
--was modified for synthesis

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity STD_FIFO is
    GENERIC (
                constant DATA_WIDTH     : positive := 8;
                constant FIFO_DEPTH	    : positive := 256
            );
    PORT    ( 
                clk		                : in  std_logic;
                rst		                : in  std_logic;
                --enables new data to be written
                writeEn	                : in  std_logic;
                --new data to write
                dataIn	                : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
                --enables data to be read
                readEn	                : in  std_logic;
                --data read
                dataOut	                : out std_logic_vector (DATA_WIDTH - 1 downto 0);
                --shows that the fifo is not empty
                not_empty	            : out std_logic;
                --shows that the fifo is full
                full	                : out std_logic
            );
end STD_FIFO;

architecture rtl of STD_FIFO is

type FIFO_Memory is array (FIFO_DEPTH - 1 downto 0) of std_logic_vector (DATA_WIDTH - 1 downto 0);
--flip flop memory
signal memory           : FIFO_Memory;
--position to write in FIFO
signal head             : integer range 0 to FIFO_DEPTH - 1;
--position to read in FIFO
signal tail             : integer range 0 to FIFO_DEPTH - 1;
--determines if writing has looped back to read
signal looped           : std_logic;


begin

	process
	begin
		wait until clk = '1';
		
        if (rst = '0') then
            head <= 0;
            tail <= 0;
            looped <= '0';
            full  <= '0';
            not_empty <= '0';
            dataOut <= (others => '0');
            memory <= (others => (others => '0'));
        else
            --checks for a read
            if (readEn = '1') then
                --makes sure that there is data to read
                if ((looped = '1') or (head /= tail)) then
                    --read the memory position
                    dataOut <= memory(tail);
                    --checks to see if last position in FIFO
                    if (tail = FIFO_DEPTH - 1) then
                        --reset back to 0
                        tail <= 0;
                        --turn off looped 
                        looped <= '0';
                    else
                        --increase read positino
                        tail <= tail + 1;
                    end if;
                else 
                    --no data in FIFO, send out 0's
                    dataOut <= (others => '0');
                end if;
            else 
                --no data in FIFO, send out 0's
                dataOut <= (others => '0');
            end if;
            
            --checks to see if write is enabled
            if (writeEn = '1') then
                --makes sure that there is still space to write
                if ((looped = '0') or (head /= tail)) then
                    --write in data into FIFO
                    memory(head) <= dataIn;
                    --checks to see if last index in FIFO
                    if (head = FIFO_DEPTH - 1) then
                        --reset write position
                        head <= 0;
                        --set looped to true
                        looped <= '1';
                    else
                        --increase write position
                        head <= head + 1;
                    end if;
                end if;
            end if;
            
            --checks to see if read and write position match
            if (head = tail) then
                --checks to see if it is looped
                if (looped = '1')then
                    --looped therefor FIFO is full
                    not_empty <= '1';
                    full <= '1';
                else
                    --not looped therefor FIFO is empty
                    not_empty <= '0';
                    full <= '0';
                end if;
            else
                --read and write dont match therefor data exist
                --but not full
                not_empty	<= '1';
                full	<= '0';
            end if;
        end if;
	end process;
		
end rtl;