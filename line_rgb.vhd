----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/08/2019 03:39:41 PM
-- Design Name: 
-- Module Name: line_rgb - rtl
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

entity line_rgb is
    PORT    (   
                clk                     : in    std_logic;
                rst                     : in    std_logic;
                
                --amount of pixel rows in the line buffer, MAX amount of rows is 7
                row                     : in    integer range 0 to 7;
                --amount of pixel columns in the line buffer, MAX amount of columns is 4096
                column                  : in    integer range 0 to 4096;
                --kernel length of columns, assumes max kernel size is 8x8
                k_column                : in    integer range 0 to 8;
                --reset signal in case of resize of line buffer or kernel
                resize_line             : in    std_logic;
                
                --new data for red line buffer
                data_red_in             : in    std_logic_vector(7 downto 0);
                --new data for green line buffer
                data_green_in           : in    std_logic_vector(7 downto 0);
                --new data for blue line buffer
                data_blue_in            : in    std_logic_vector(7 downto 0);
                
                --flag for request of new data for rgb to kernel_color
                line_request             : out   std_logic;
                --flag for when kernel_color sent new rgb data
                kernel_sent              : in   std_logic;
                
                --red data sent to kernel color
                data_red_out            : out   std_logic_vector(55 downto 0);
                --green data sent to kernel color
                data_green_out          : out   std_logic_vector(55 downto 0);
                --blue data sent to kernel color
                data_blue_out           : out   std_logic_vector(55 downto 0);
                
                --flag for request of new data for rgb from kernel_color
                kernel_request          : in    std_logic;
                --flag for when line_color sent new rgb data
                line_sent               : out   std_logic;
                
                --flag for when line_color is full
                full                    : out   std_logic
            );
end line_rgb;

architecture rtl of line_rgb is
    
    --signal used for each line buffer has sent data to kernel
    signal red_flag             : std_logic;
    signal green_flag           : std_logic;
    signal blue_flag            : std_logic;
    --signal used for each line buffer requesting data
    signal red_request          : std_logic;
    signal green_request        : std_logic;
    signal blue_request         : std_logic;
    --signal used for each line buffer being full
    signal full_red             : std_logic;
    signal full_green           : std_logic;
    signal full_blue            : std_logic;
    
    component line_buff is
        PORT    (
                    clk                     : in    std_logic;
                    rst                     : in    std_logic;
                    
                    --amount of pixel rows in the line buffer, MAX amount of rows is 7
                    row                     : in    integer range 0 to 7;
                    --amount of pixel columns in the line buffer, MAX amount of columns is 4095
                    column                  : in    integer range 0 to 4096;
                    --kernel length of columns, assumes max kernel size is 8x8
                    k_column                : in    integer range 0 to 8;
                    --reset signal in case of resize of line buffer or kernel
                    resize_line             : in    std_logic;
                    
                    --new data to be placed in line buffer
                    data_in                 : in    std_logic_vector(7 downto 0);
                    --flag for when new data is ready to be read in
                    data_in_flag            : in    std_logic;
                    --line request more data
                    line_request            : out   std_logic;
                    
                    --data sent to the kernel buffer, assumes MAX kernel is 8x8
                    data_out                : out   std_logic_vector(55 downto 0);
                    --flag for when kernel buffer should read in data_out
                    data_out_flag           : out   std_logic;
                    --kernel request more data
                    kernel_request          : in    std_logic;
                    
                    --flag when line_buff is full
                    full                    : out   std_logic
                );
    end component;
    
begin

    red_line: line_buff
        PORT MAP    (   
                        clk                 => clk,
                        rst                 => rst,
                        row                 => row,
                        column              => column,
                        k_column            => k_column,
                        resize_line         => resize_line,
                        data_in             => data_red_in,
                        data_in_flag        => kernel_sent,
                        line_request        => red_request,
                        data_out            => data_red_out,
                        data_out_flag       => red_flag,
                        kernel_request      => kernel_request,
                        full                => full_red
                    );
                    
    green_line: line_buff
        PORT MAP    (   
                        clk                 => clk,
                        rst                 => rst,
                        row                 => row,
                        column              => column,
                        k_column            => k_column,
                        resize_line         => resize_line,
                        data_in             => data_green_in,
                        data_in_flag        => kernel_sent,
                        line_request        => green_request,
                        data_out            => data_green_out,
                        data_out_flag       => green_flag,
                        kernel_request      => kernel_request,
                        full                => full_green
                    );
                    
    blue_line: line_buff
        PORT MAP    (   
                        clk                 => clk,
                        rst                 => rst,
                        row                 => row,
                        column              => column,
                        k_column            => k_column,
                        resize_line         => resize_line,
                        data_in             => data_blue_in,
                        data_in_flag        => kernel_sent,
                        line_request        => blue_request,
                        data_out            => data_blue_out,
                        data_out_flag       => blue_flag,
                        kernel_request      => kernel_request,
                        full                => full_blue
                    );
    
    --process combines all request for data from each line buffer to one request of all colors
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            line_request <= '0';
        else
            line_request <= red_request and green_request and blue_request;
        end if;
    end process;
    
    --process combines all colors sent from each line buffer to one of all colors sent
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            line_sent <= '0';
        else
            line_sent <= red_flag and green_flag and blue_flag;
        end if;
    end process;
    
    --process combines each line buffer being full to one full flag
    process
    begin
        --waits until rising edge
        wait until clk = '1';
    
        if(rst = '0') then
            full <= '0';
        else
            full <= full_red and full_green and full_blue;
        end if;
    end process;

end rtl;
