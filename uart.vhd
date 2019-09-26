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
                
                --used to read data from RX FIFO
                rx_fifo_renable         : in    std_logic;
                uart_data_out           : out   std_logic_vector(7 downto 0);
                uart_rx_not_empty       : out   std_logic;
                
                --used to write data to TX FIFO
                tx_fifo_wenable         : in    std_logic;
                uart_data_in            : in    std_logic_vector(7 downto 0);
                uart_tx_full            : out   std_logic;
                
                --physical ports for UART
                RX                      : in    std_logic;
                rts                     : out   std_logic;
                TX                      : out   std_logic;
                cts                     : in    std_logic;
                
                --used for debuggin
                temp                    : out   std_logic
            );
end uart;

architecture rtl of uart is

signal rx_fifo_full         : std_logic;
signal rx_fifo_wdata        : std_logic_vector(7 downto 0);
signal rx_fifo_wenable      : std_logic;

signal tx_fifo_not_empty        : std_logic;
signal tx_fifo_rdata        : std_logic_vector(7 downto 0);
signal tx_fifo_renable      : std_logic;


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
                    data                        : out   std_logic_vector(7 downto 0);
                    rts                         : out   std_logic;
                    --used to determine if the FIFO is full
                    fifo_full                   : in    std_logic
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
               
                    --enable line to send data (enable low)
                    enable                      : in    std_logic;
                    --data to send
                    data                        : in    std_logic_vector(7 downto 0);
                    --data sent over uart
                    tx                          : out   std_logic;
                    --flag that shows all data has been sent
                    flag                        : out   std_logic;
                    cts                         : in    std_logic
                );
    end component;
    
    
    component STD_FIFO is
        GENERIC (
                    constant DATA_WIDTH         : positive := 8;
                    constant FIFO_DEPTH         : positive := 256
                );
        PORT    ( 
                    clk                         : in  std_logic;
                    rst                         : in  std_logic;
                    writeEn                     : in  std_logic;
                    dataIn                      : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
                    readEn                      : in  std_logic;
                    dataOut                     : out std_logic_vector (DATA_WIDTH - 1 downto 0);
                    not_empty                   : out std_logic;
                    full                        : out std_logic
                );
    end component;
    
begin

    rx_fifo: STD_FIFO
        GENERIC MAP (
                        DATA_WIDTH      => 8,
                        FIFO_DEPTH      => 256
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        writeEn         => rx_fifo_wenable,
                        dataIn          => rx_fifo_wdata,
                        readEn          => rx_fifo_renable,
                        dataOut         => uart_data_out,
                        not_empty       => uart_rx_not_empty,
                        full            => rx_fifo_full
                    );
    
    
    my_uart_rx: uart_rx
        GENERIC MAP (
                        CLK_SPEED       => CLK_SPEED,
                        BAUD_RATE       => BAUD_RATE
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        rx              => RX,
                        flag            => rx_fifo_wenable,
                        data            => rx_fifo_wdata,
                        rts             => rts,
                        fifo_full       => rx_fifo_full
                    );
                    
    tx_fifo: STD_FIFO
        GENERIC MAP (
                        DATA_WIDTH      => 8,
                        FIFO_DEPTH      => 256
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        writeEn         => tx_fifo_wenable,
                        dataIn          => uart_data_in,
                        readEn          => tx_fifo_renable,
                        dataOut         => tx_fifo_rdata,
                        not_empty       => tx_fifo_not_empty,
                        full            => uart_tx_full
                    );
                    
    my_uart_tx: uart_tx
        GENERIC MAP (   
                        CLK_SPEED       => CLK_SPEED,
                        BAUD_RATE       => BAUD_RATE
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        enable          => tx_fifo_not_empty,
                        data            => tx_fifo_rdata,
                        tx              => TX,
                        flag            => tx_fifo_renable,
                        cts             => cts
                    );
    
    temp <= tx_fifo_not_empty;

end rtl;
