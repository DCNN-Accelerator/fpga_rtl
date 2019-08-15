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
signal data             : std_logic_vector(23 downto 0) := X"000000";
signal ena              : std_logic := '0';
signal ready_check      : std_logic;

signal data_read        : std_logic_vector(23 downto 0);
signal new_data         : std_logic;

signal uart_conn        : std_logic;
signal value            : integer := 0;
    
    component uart 
        GENERIC (   
                    CLK_SPEED               : integer;
                    BAUD_RATE               : integer
                );
        PORT    (   
                    clk                     : in    std_logic;
                    rst                     : in    std_logic;
                    
                    --used for transmitting data
                    --data to send over uart
                    data_tx                 : in    std_logic_vector(23 downto 0);
                    --uart transmission line for sending data
                    tx_uart                 : out   std_logic;
                    --signals when to send out new data over uart
                    enable_tx               : in    std_logic;
                    --signals that it is ready to send data again
                    ready_tx                : out   std_logic;
                    
                    --used for receiving data
                    --data received over uart
                    data_rx                 : out   std_logic_vector(23 downto 0);
                    --uart transmission line for receiving data
                    rx_uart                 : in    std_logic;
                    --signals when new data was clocked in
                    new_rx                  : out   std_logic
                );
    end component;

begin

    my_uart: uart
        GENERIC MAP (
                        CLK_SPEED           => 100_000_000,
                        BAUD_RATE           => 10_000_000
                    )
        PORT MAP    (
                        clk                 => clk_100,
                        rst                 => rst_100,
                        data_tx             => data,
                        tx_uart             => uart_conn,
                        enable_tx           => ena,
                        ready_tx            => ready_check,
                        data_rx             => data_read,
                        rx_uart             => uart_conn,
                        new_rx              => new_data
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
        wait until clk_100 = '1';
        
        if(rst_100 = '1') then
            if(ready_check = '1') then
                value <= value + 1;
                data <= std_logic_vector(to_unsigned(value, 24));
                ena <= '1';
            else
                ena <= '0';
            end if;
        end if;
    end process;
    
end rtl;
