----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/08/2019 01:45:55 PM
-- Design Name: 
-- Module Name: uart_tx - rtl
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

entity uart_tx is
    GENERIC (
                CLK_SPEED                   :   integer;
                BAUD_RATE                   :   integer
            );
    PORT    (
                clk                         : in    std_logic;
                rst                         : in    std_logic;
           
                --enable line to send data
                enable                      : in    std_logic;
                --data to send
                data                        : in    std_logic_vector(23 downto 0);
                --data sent over uart
                tx                          : out   std_logic;
                --flag that shows all data has been sent
                flag                        : out   std_logic
            );
end uart_tx;

architecture rtl of uart_tx is

--state machine
type my_states is (idle, start, running, stop);

--current state of the machine
signal state            : my_states;
--counter used for clocks per bit
signal counter          : integer range 0 to CLK_SPEED / BAUD_RATE - 1;
--counts amount of bits sent
signal bits             : integer range 0 to 23;
--signal that latches in data when enable goes high
signal latch            : std_logic_vector(23 downto 0);

begin

    --process handles states
    process
    begin
        --waits for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            tx <= '1';
            flag <= '1';
            state <= idle;
            counter <= 0;
            bits <= 0;
            latch <= (others => '0');
        else
            case(state) is
                --waits for enable to be set
                when idle =>
                    --checks to see if enable is set
                    if(enable = '1') then
                        --move to send out start bit
                        state <= start;
                        --set flag for data sent to false
                        flag <= '0';
                        --latch in data
                        latch <= data;
                    else
                        --not enabled, reset values
                        tx <= '1';
                        flag <= '1';
                        counter <= 0;
                        bits <= 0;
                        latch <= (others => '0');
                    end if;
                    
                --sends out start bit
                when start =>
                    --checks to see if it waited long enough
                    if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                        --reset counter and move to send out data
                        counter <= 0;
                        state <= running;
                    else
                        --wait for counter to finish
                        counter <= counter + 1;
                        --set the tx line to low 
                        tx <= '0';
                    end if;
                    
                --sends out byte over uart
                when running =>
                    --outputs data LSB first 
                    tx <= latch(0);
                    
                    --waits for data to be ready to update
                    if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                        --reset counter
                        counter <= 0;
                        --checks to see if all data has been sent
                        if(bits = 23) then
                            --moves to stop bit
                            state <= stop;
                        else
                            --increase bits read
                            bits <= bits + 1;
                            --shift latch 
                            latch(22 downto 0) <= latch(23 downto 1);
                        end if;
                    else    
                        --continue to count 
                        counter <= counter + 1;
                    end if;
                
                --waits until stop bit is done before rasing flag    
                when stop =>
                    --sets stop bit
                    tx <= '1';
                    if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                        --move back to idle
                        state <= idle;
                        --set flag for data sent
                        flag <= '1';
                    else    
                        counter <= counter + 1;
                    end if;
                
                --state is unknown, should not occur
                when others =>
                    state <= idle;
            end case;
        end if;
    end process;

end rtl;
