----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/02/2019 08:15:34 AM
-- Design Name: 
-- Module Name: data_handler - rtl
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


entity data_handler is
    PORT    (
                clk                         : in    std_logic;
                rst                         : in    std_logic;
                
                --soft reset
                softreset                   : out   std_logic;
                
                --new data to buff
                d2b_request                 : in    std_logic;
                d2b_flag_out                : out   std_logic;
                d2b_out                     : out   std_logic_vector(23 downto 0);
                
                --buff data from buffer to convolution
                b2c_flag_in                 : in    std_logic;
                b2c_flag_out                : out   std_logic;
                
                --data to filter values
                f_flag_out                  : out   std_logic;
                f_data                      : out   std_logic_vector(23 downto 0);
                
                --data from convolution
                red_conv                    : in    std_logic_vector(17 downto 0);
                green_conv                  : in    std_logic_vector(17 downto 0);
                blue_conv                   : in    std_logic_vector(17 downto 0);
                conv_done                   : in    std_logic;
                
                --data from uart
                rx_uart                     : in    std_logic_vector(23 downto 0);
                --shows new data was read
                rx_new                      : in    std_logic;
                
                --data to uart
                tx_uart                     : out   std_logic_vector(23 downto 0);
                --enables tx_uart to be sent
                uart_ena                    : out   std_logic;
                --shows if uart is currently transmitting
                tx_ready                    : in    std_logic
            );
end data_handler;

architecture rtl of data_handler is

type state_type is (idle, handshake_send, handshake_receive, start, filling, running, wait4conv, done);
type color_type is (idle, red, green, blue);

--state machine 
signal state                    : state_type;
signal color                    : color_type;
--amount of pixels sent over uart. Max size is 4k image size
signal pixel_counter            : integer range 0 to 4096 * 2160;
--waits until uart rx_new flag has reset
signal rx_flag                  : std_logic;


begin

    
    --process handles state machine
    process
    begin
        --waits for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            
        else
            case (state) is
                --checks to see if first part of handshake is sent
                when idle =>
                    --makes sure soft_reset isnt on
                    softreset <= '1';
                    --checks for new data sent
                    if(rx_new = '1') then
                        --set flag to false
                        rx_flag <= '0';
                        --sees if handshake matches
                        if(rx_flag = '1' and rx_uart = X"FAFA00") then
                            --handshake sequence beginning, move to handshake
                            state <= handshake_send;
                        end if;
                    else
                        --reset flag to true
                        rx_flag <= '1';
                    end if;
                    
                --sends reply for handshake
                when handshake_send =>
                    --checks to see if it is able to send
                    if(tx_ready = '1') then
                        --set data to send
                        tx_uart <= X"00FFAA";
                        --enable uart
                        uart_ena <= '1';
                        --move to see if PC acknowledges handshake
                        state <= handshake_receive;
                    end if;
                    
                --checks to see if PC saw our response
                when handshake_receive =>
                    --turn off uart tx
                    uart_ena <= '0';
                    
                    --checks for a new value
                    if(rx_new <= '0') then
                        --set flag to false
                        rx_flag <= '0';
                        if(rx_flag = '1') then
                            --checks to see if appropiate response
                            if(rx_uart = X"012345") then
                                --start sequence confirmed
                                state <= start;
                            else
                                --wrong response, go back to idle
                                state <= idle;
                            end if;
                        end if;
                    else
                        --reset flag
                        rx_flag <= '1';
                    end if;
                    
                --in start sequence, save all filter data
                when start =>
                    --checks for new data 
                    if(rx_new = '1') then
                        --set flag to false
                        rx_flag <= '0';
                        if(rx_flag = '1') then
                            --save new data that was sent
                            f_data <= rx_uart;
                            --set flag for data sent
                            f_flag_out <= '1';
                            
                            --examines amount of packets sent to determine if all filters were recieved
                            case (pixel_counter) is
                                --red filter
                                when 0 to 16 =>
                                    --increase pixel_counter
                                    pixel_counter <= pixel_counter + 1;
                                   
                                --green filter
                                when 17 to 33 =>
                                    --increase pixel_counter 
                                    pixel_counter <= pixel_counter + 1;
                                
                                --blue filter
                                when 34 to 50 =>
                                    --increase pixel_counter 
                                    pixel_counter <= pixel_counter + 1;
                                    
                                --all filters sent
                                when others =>
                                    pixel_counter <= 0;
                                    state <= filling;
                            end case;
                        end if;
                    else
                        --reset flags
                        f_flag_out <= '0';
                        rx_flag <= '1';
                    end if;
                    
                --currently receiving data to fill buff so that one convolution can occur
                when filling =>
                    --turn off f_flag_out
                    f_flag_out <= '0';
                    
                    --waits for new data to be sent
                    if(rx_new = '1') then
                        --set flag to false
                        rx_flag <= '0';
                        if(rx_flag <= '1') then
                            --check to make sure buff is requesting data
                            if(d2b_request = '1') then
                                --send data to buff
                                d2b_out <= rx_uart;
                                d2b_flag_out <= '1';
                            else
                                --buff doesnt want data ??????
                            end if;
                            
                            --check to see if enough pixels were recieved to do one convolution
                            --right now using 3 full rows and 4 pixels in 4th row is enough data
                            if(pixel_counter = 12291) then
                                state <= wait4conv;
                                --reset flags
                                rx_flag <= '1';
                                d2b_flag_out <= '0';
                                --set color to red
                                color <= red;
                                
                                --allows data from buffer to convolution
                                b2c_flag_out <= b2c_flag_in;
                                
                                --reset so we can count how many pixels we have sent back
                                pixel_counter <= 0;
                            else
                                --increase pixels read
                                pixel_counter <= pixel_counter + 1;
                            end if;
                        end if;
                    else
                        --reset flags
                        rx_flag <= '1';
                        d2b_flag_out <= '0';
                    end if;
                    
                --waiting for convolution to finish to send result
                when wait4conv =>
                    --turns off b2c_flag
                    b2c_flag_out <= '0';
                    
                    --checks to see if convolution is done
                    if(conv_done = '1') then
                        --checks to see if uart is ready
                        if(tx_ready = '1') then
                            --enable uart and set data to send
                            uart_ena <= '1';
                                case (color) is
                                    --send out red data and change so next color sent is green
                                    when red =>
                                        tx_uart(17 downto 0) <= red_conv;
                                        color <= green;
                                    
                                    --send out green data and change so next color sent is blue
                                    when green =>
                                        tx_uart(17 downto 0) <= green_conv;
                                        color <= blue;
                                    
                                    --send out blue data and change to idle
                                    when blue =>
                                        tx_uart(17 downto 0) <= blue_conv;
                                        color <= idle;
                                    
                                    --should not occur, so recieve data again
                                    when idle =>
                                        state <= running;
                                end case;
                            tx_uart(23 downto 18) <= (others => '0');
                        else
                            --busy sending data so turn off enable
                            uart_ena <= '0';
                            --checks to see if all pixels are sent
                            if(pixel_counter = 4096 * 2160) then
                                state <= done;
                            else
                                --check to see if idling
                                if(color = idle) then
                                    --idling so move to recieve data again
                                    state <= running;
                                    --increase pixels sent
                                    pixel_counter <= pixel_counter + 1;
                                end if;
                            end if;
                        end if;
                    end if;
                    
                --currently running to grab more data
                when running =>
                    --waits for new data to be sent
                    if(rx_new = '1') then
                        --set flag to false
                        rx_flag <= '0';
                        if(rx_flag <= '1') then
                            --check to make sure buff is requesting data
                            if(d2b_request = '1') then
                                --send data to buff
                                d2b_out <= rx_uart;
                                d2b_flag_out <= '1';
                            else
                                --buff doesnt want data ??????
                            end if;
                            
                            --changes state to wait for convolution result
                            state <= wait4conv;
                            --reset flags
                            rx_flag <= '1';
                            d2b_flag_out <= '0';
                            --change color to red
                            color <= red;
                            
                            --allows data from buffer to conv
                            b2c_flag_out <= b2c_flag_in;
                        end if;
                    else
                        --reset flags
                        rx_flag <= '1';
                        d2b_flag_out <= '0';
                    end if;
                    
                --done sending all convolution data
                when done =>
                    state <= idle;
                    --issue a soft reset
                    softreset <= '0';
                    
                --should not occur
                when others =>
            end case;
        end if;
    end process;
       
end rtl;
