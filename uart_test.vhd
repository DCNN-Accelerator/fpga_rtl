----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2019 02:19:00 PM
-- Design Name: 
-- Module Name: uart_test - rtl
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


entity uart_test is
--  Port ( );
end uart_test;

architecture rtl of uart_test is

signal clk_100          : std_logic := '0';
signal rst_100          : std_logic := '0';

signal value            : integer := 0;

signal read             : std_logic := '0';
signal read_data        : std_logic_vector(7 downto 0);
signal empty            : std_logic;

signal write            : std_logic := '0';
signal write_data       : std_logic_vector(7 downto 0) := X"00";
signal full             : std_logic;

signal line1            : std_logic;
signal line2            : std_logic;
    
    component uart is
        GENERIC (   
                    CLK_SPEED               : integer;
                    BAUD_RATE               : integer
                );
        PORT    (   
                    clk                     : in    std_logic;
                    rst                     : in    std_logic;
                    
                    --used to read data from RX FIFO
                    rx_fifo_renable         : in    std_logic;
                    uart_data_out           : out   std_logic_vector(7 downto 0);
                    uart_rx_empty           : out   std_logic;
                    
                    --used to write data to TX FIFO
                    tx_fifo_wenable         : in    std_logic;
                    uart_data_in            : in    std_logic_vector(7 downto 0);
                    uart_tx_full            : out   std_logic;
                    
                    --physical ports for UART
                    RX                      : in    std_logic;
                    rts                     : out   std_logic;
                    TX                      : out   std_logic;
                    cts                     : in    std_logic
                );
    end component;

begin

    my_uart: uart
        GENERIC MAP (
                        CLK_SPEED           => 100_000_000,
                        BAUD_RATE           => 25_000_000
                    )
        PORT MAP    (
                        clk                 => clk_100,
                        rst                 => rst_100,
                        rx_fifo_renable     => read,
                        uart_data_out       => read_data,
                        uart_rx_empty       => empty,
                        tx_fifo_wenable     => write,
                        uart_data_in        => write_data,
                        uart_tx_full        => full,
                        RX                  => line1,
                        rts                 => line2,
                        TX                  => line1,
                        cts                 => line2
                    );

    process
    begin
        wait for 5 ns;
        clk_100 <= not clk_100;
    end process;
    
    process 
    begin
        wait until clk_100 = '1';
        
        if(rst_100 = '0') then
            rst_100 <= '1';
        end if;
    end process;
    
    process
    begin
        wait until clk_100 = '0';
        
        if(rst_100 = '1') then
            if(full = '0') then
                value <= value + 1;
                write_data <= std_logic_vector(to_unsigned(value, 8));
            end if;
            write <= not full;
            
            read <= empty;
        end if;
    end process;
    
end rtl;
