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
                
                --sizes
                row                         : out   integer range 0 to 7;
                column                      : out   integer range 0 to 4096;
                k_row                       : out   integer range 0 to 8;
                k_column                    : out   integer range 0 to 8;
                
                --softcore reset
                softreset                   : out   std_logic;
                
                --data ready flag from line buffer to kernel buffer
                line2kernel_flag_in         : in    std_logic;
                line2kernel_flag_out        : out   std_logic;
                
                --data ready flag from kernel buffer to line buffer
                kernel2line_flag_in         : in    std_logic;
                kernel2line_flag_out        : out   std_logic;
                
                --data ready flag from memory to kernel buffer
                mem2kernel_flag_in          : in    std_logic;
                mem2kernel_flag_out         : out   std_logic;
                mem2kernel_data_red         : out   std_logic_vector(7 downto 0);
                mem2kernel_data_green       : out   std_logic_vector(7 downto 0);
                mem2kernel_data_blue        : out   std_logic_vector(7 downto 0);
                
                
                --data ready flag from kernel buffer to convolution
                kernel2conv_flag_in         : in    std_logic;
                kernel2conv_flag_out        : out   std_logic;
                
                --convolution data
                conv_red                    : in    std_logic_vector(17 downto 0);
                conv_green                  : in    std_logic_vector(17 downto 0);
                conv_blue                   : in    std_logic_vector(17 downto 0);
                conv_done                   : in    std_logic;
                
                --data from memory
                mem_data                    : in    std_logic_vector(15 downto 0);
                
                --data from uart
                rx_uart                     : in    std_logic_vector(23 downto 0);
                --shows new data was read
                rx_new                      : in    std_logic;
                
                --data to uart
                tx_uart                     : out   std_logic_vector(23 downto 0);
                --enables tx_uart to be sent
                uart_ena                    : out   std_logic;
                --shows if uart is currently transmitting
                tx_ready                    : in    std_logic;
                
                --line buffer is full
                full                        : in    std_logic
            );
end data_handler;

architecture rtl of data_handler is

type state_type is (idle, start, running, done);
type color_type is (idle, red, green, blue);

--state machine 
signal state                    : state_type;
--amount of pixels sent over uart. Max size is 4k image size
signal pixel_counter             : integer range 0 to 4096 * 2160;
--waits until uart rx_new flag has reset
signal rx_flag                  : std_logic;


begin

    --process waits until all data is ready before letting flags for data set being true
    --probably has to be changed but general idea of how it handles the flags
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            line2kernel_flag_out <= '0';
            kernel2line_flag_out <= '0';
            mem2kernel_flag_out <= '0';
            kernel2conv_flag_out <= '0';
        else
            --checks to see if the line buffer is full yet
            if(full = '0') then
                --line buffer is not full, dont send data to convolution
                --checks to see if all flags are set for data ready to be sent out
                if(line2kernel_flag_in = '1' and kernel2line_flag_in = '1' and mem2kernel_flag_in = '1') then
                    --all flags set, allow data to pass
                    line2kernel_flag_out <= '1';
                    kernel2line_flag_out <= '1';
                    mem2kernel_flag_out <= '1';
                else
                    --flags are not all set, wait for data to be ready
                    line2kernel_flag_out <= '0';
                    kernel2line_flag_out <= '0';
                    mem2kernel_flag_out <= '0';
                end if;
            else
                --line buffer is full of data, also wait for convolution to be ready
                --checks to see if all flags are set for data ready to be sent out
                if(line2kernel_flag_in = '1' and kernel2line_flag_in = '1' and mem2kernel_flag_in = '1' and kernel2conv_flag_in = '1') then
                    --all flags set, allow data to pass
                    line2kernel_flag_out <= '1';
                    kernel2line_flag_out <= '1';
                    mem2kernel_flag_out <= '1';
                    kernel2conv_flag_out <= '1';
                else
                    --flags are not all set, wait for data to be ready
                    line2kernel_flag_out <= '0';
                    kernel2line_flag_out <= '0';
                    mem2kernel_flag_out <= '0';
                    kernel2conv_flag_out <= '0';
                end if;
            end if;
        
        end if;
    end process;
    
    --process handles state machine
    process
    begin
        --waits for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            state <= idle;
            pixel_counter <= 0;
            rx_flag <= '1';
            softreset <= '1';
        else
            case (state) is
                --has not received start packet from PC, watch for packet
                when idle =>
                    --packet from pc has arrived
                    if(rx_new = '1') then
                        --set the rx_flag to false
                        rx_flag <= '0';
                        --checks for correct sequence and the rx_flag is true
                        if(rx_uart = X"FAFA00FFFAFA" and rx_flag = '1') then
                            --move to start
                            state <= start;
                            pixel_counter <= 1;
                        end if;
                    else
                        --reset pxiels read
                        pixel_counter <= 0;
                        --rx_new is low so new data can be read when it goes high again
                        rx_flag <= '1';
                    end if;
                    
                when start =>
                    --checks to see which packet pc is sending
                    case pixel_counter is
                        --first packet is line_buffer size
                        when 1 =>
                            --check for packet
                            if(rx_new = '1') then
                                --set flag to false to wait for rx_new to go low
                                rx_flag <= '0';
                                if(rx_flag = '1') then
                                    --convert std_logic_vector to unsigned integer
                                    --row has max size of 7 so look at last 3 bits
                                    row <= to_integer(unsigned(rx_uart(2 downto 0)));
                                    --column has max size of 4096 so look at next 13 bits
                                    column <= to_integer(unsigned(rx_uart(15 downto 3)));
                                    --increase to pixel
                                    pixel_counter <= 2;
                                end if;
                            else
                                --allow new data
                                rx_flag <= '1';
                            end if;
                            
                        --second packet is kernel_buffer size
                        when 2 =>
                            --check for packet
                            if(rx_new = '1') then
                                --set flag to false to wait for rx_new to go low
                                rx_flag <= '0';
                                if(rx_flag = '1') then
                                    --convert std_logic_vector to unsigned integer
                                    --k_row has max size of 8 so look at last 4 bits
                                    k_row <= to_integer(unsigned(rx_uart(3 downto 0)));
                                    --k_column has max size of 8 so look at last 4 bits
                                    k_column <= to_integer(unsigned(rx_uart(7 downto 4)));
                                    --increase to pixel
                                    pixel_counter <= 3;
                                end if;
                            else
                                --allow new data
                                rx_flag <= '1';
                            end if;
                            
                        --third packet is image size
                        when 3 =>
                            --check for packet
                            if(rx_new = '1') then
                                --set flag to false to wait for rx_new to go low
                                rx_flag <= '0';
                                if(rx_flag = '1') then
                                    --set pixel_counter to the image size
                                    pixel_counter <= to_integer(unsigned(rx_uart));
                                    --issue soft reset to other parts (resize_line)
                                    softreset <= '0';
                                    --move to running to acqure pixel values
                                    state <= running;
                                end if;
                            else
                                --allow new data
                                rx_flag <= '1';
                            end if;
                        
                        --should not occur 
                        when others =>
                            pixel_counter <= 1;
                    end case;
                
                when running =>
                    --turn off soft reset
                    softreset <= '1';
                    --checks to see if there are still pixels to be read
                    if(pixel_counter = 0) then
                        --no more pixels left, move to done
                        state <= done;
                    else
                        
                        --decrease amount of pixels left
                        pixel_counter <= pixel_counter - 1;
                    end if;
                
                when done =>
                    
                --should not occur
                when others =>
                    state <= idle;
            end case;
        end if;
    end process;
       
end rtl;
