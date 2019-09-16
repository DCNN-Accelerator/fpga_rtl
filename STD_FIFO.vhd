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
                writeEn	                : in  std_logic;
                dataIn	                : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
                readEn	                : in  std_logic;
                dataOut	                : out std_logic_vector (DATA_WIDTH - 1 downto 0);
                empty	                : out std_logic;
                full	                : out std_logic
            );
end STD_FIFO;

architecture rtl of STD_FIFO is

type FIFO_Memory is array (FIFO_DEPTH - 1 downto 0) of std_logic_vector (DATA_WIDTH - 1 downto 0);
signal memory           : FIFO_Memory;
signal head             : integer range 0 to FIFO_DEPTH - 1;
signal tail             : integer range 0 to FIFO_DEPTH - 1;
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
            empty <= '0';
            dataOut <= (others => '0');
            memory <= (others => (others => '0'));
        else
            if (readEn = '1') then
                if ((looped = '1') or (head /= tail)) then
                    dataOut <= memory(tail);
                    
                    if (tail = FIFO_DEPTH - 1) then
                        tail <= 0;
                        
                        looped <= '0';
                    else
                        tail <= tail + 1;
                    end if;
                else 
                    dataOut <= (others => '0');
                end if;
            else 
                dataOut <= (others => '0');
            end if;
            
            if (writeEn = '1') then
                if ((looped = '0') or (head /= tail)) then
                    memory(head) <= dataIn;
                    
                    if (head = FIFO_DEPTH - 1) then
                        head <= 0;
                        
                        looped <= '1';
                    else
                        head <= head + 1;
                    end if;
                end if;
            end if;
            
            
            if (head = tail) then
                if (looped = '1')then
                    empty <= '1';
                    full <= '1';
                else
                    empty <= '0';
                    full <= '0';
                end if;
            else
                empty	<= '1';
                full	<= '0';
            end if;
        end if;
	end process;
		
end rtl;