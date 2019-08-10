----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2019 01:28:34 PM
-- Design Name: 
-- Module Name: uart - rtl
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

entity uart is
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
end uart;

architecture rtl of uart is


    component uart_rx is
        GENERIC (
                    CLK_SPEED                   :   integer;
                    BAUD_RATE                   :   integer
                );
        PORT    (
                    clk                         : in    std_logic;
                    rst                         : in    std_logic;
                    
                    --data from uart
                    rx                          : in    std_logic;
                    --ready flag for data received  
                    flag                        : out   std_logic;
                    --data vector out
                    data                        : out   std_logic_vector(23 downto 0)
                );
    end component;
    
    component uart_tx is
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
    end component;
    
begin
    
    my_uart_rx: uart_rx
        GENERIC MAP (
                        CLK_SPEED       => CLK_SPEED,
                        BAUD_RATE       => BAUD_RATE
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        rx              => rx_uart,
                        flag            => new_rx,
                        data            => data_rx
                    );
                    
    my_uart_tx: uart_tx
        GENERIC MAP (   
                        CLK_SPEED       => CLK_SPEED,
                        BAUD_RATE       => BAUD_RATE
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        enable          => enable_tx,
                        data            => data_tx,
                        tx              => tx_uart,
                        flag            => ready_tx
                    );

end rtl;
