----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/08/2019 03:39:41 PM
-- Design Name: 
-- Module Name: kernel_rgb - rtl
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

entity kernel_rgb is
    PORT    (
                clk                          : in    std_logic;
                rst                          : in    std_logic;
                                
                --amount of pixel rows in kernel
                k_row                       : in    integer range 0 to 8;
                --amount of pixel columns in kernel   
                k_column                    : in    integer range 0 to 8;
                --reset signal in case of resize of line buffer or kernel
                resize_line                 : in    std_logic;
                                
                --red data comes from line buffer
                data_line_red               : in    std_logic_vector(55 downto 0);
                --green data comes from line buffer
                data_line_green             : in    std_logic_vector(55 downto 0);
                --blue data comes from line buffer
                data_line_blue              : in    std_logic_vector(55 downto 0);
                --flag that data_line is ready  
                data_line_flag              : in    std_logic;  
                --kernel requesting data from line buffer
                kernel_request_line         : out   std_logic;
                                
                --red data that goes to line buffer
                data_out_red                : out   std_logic_vector(7 downto 0);
                --green data that goes to line buffer
                data_out_green              : out   std_logic_vector(7 downto 0);
                --blue data that goes to line buffer
                data_out_blue               : out   std_logic_vector(7 downto 0);
                --flag that data_out is ready
                data_out_flag               : out   std_logic;
                --line requesting data from kernel
                line_request                : in    std_logic;
                                
                --red data comes from memory
                data_mem_red                : in    std_logic_vector(7 downto 0);
                --green data comes from memory
                data_mem_green              : in    std_logic_vector(7 downto 0);
                --blule data comes from memory
                data_mem_blue               : in    std_logic_vector(7 downto 0);
                --flag that data_mem is ready
                data_mem_flag               : in    std_logic;
                --kernel requesting data from memory
                kernel_request_mem          : out   std_logic;
                                
                --entire red kernal buffer 
                k_buff_red                  : out   std_logic_vector(511 downto 0);
                --entire green kernel buffer
                k_buff_green                : out   std_logic_vector(511 downto 0);
                --entire blue kernel buffer
                k_buff_blue                 : out   std_logic_vector(511 downto 0);
                --flag that k_buff is ready
                k_buff_flag                 : out   std_logic;
                --convolution filter requesting data
                conv_request                : in    std_logic    
            );
end kernel_rgb;

architecture rtl of kernel_rgb is

    --signals of kernel requesting data from line buffer
    signal k2l_red_request                  : std_logic;
    signal k2l_green_request                : std_logic;
    signal k2l_blue_request                 : std_logic;
    --signals of data from kernel to line buffer is ready
    signal red_flag                         : std_logic;
    signal green_flag                       : std_logic;
    signal blue_flag                        : std_logic;
    --signals of kernel requesting data from memory
    signal k2m_red_request                  : std_logic;
    signal k2m_green_request                : std_logic;
    signal k2m_blue_request                 : std_logic;
    --signals of kernel sent data from its entire buffer
    signal red_buff_flag                    : std_logic;
    signal green_buff_flag                  : std_logic;
    signal blue_buff_flag                   : std_logic;

    component kernel_buff is
        PORT    (   
                    clk                         : in    std_logic;
                    rst                         : in    std_logic;
                    
                    --amount of pixel rows in kernel
                    k_row                       : in    integer range 0 to 8;
                    --amount of pixel columns in kernel   
                    k_column                    : in    integer range 0 to 8;
                    --reset signal in case of resize of line buffer or kernel
                    resize_line                  : in    std_logic;
                    
                    --data comes from line buffer
                    data_line                   : in    std_logic_vector(55 downto 0);
                    --flag that data_line is ready  
                    data_line_flag              : in    std_logic;  
                    --kernel requesting data from line buffer
                    kernel_request_line         : out   std_logic;
                    
                    --data that goes to line buffer
                    data_out                    : out   std_logic_vector(7 downto 0);
                    --flag that data_out is ready
                    data_out_flag               : out   std_logic;
                    --line requesting data from kernel
                    line_request                : in    std_logic;
                    
                    --data comes from memory
                    data_mem                    : in    std_logic_vector(7 downto 0);
                    --flag that data_mem is ready
                    data_mem_flag               : in    std_logic;
                    --kernel requesting data from memory
                    kernel_request_mem          : out   std_logic;
                    
                    --entire kernal buffer 
                    k_buff                      : out   std_logic_vector(511 downto 0);
                    --flag that k_buff is ready
                    k_buff_flag                 : out   std_logic;
                    --convolution filter requesting data
                    conv_request                : in    std_logic
                );
    end component;

begin

    red_kernel: kernel_buff
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        k_row               => k_row,
                        k_column            => k_column,
                        resize_line         => resize_line,
                        data_line           => data_line_red,
                        data_line_flag      => data_line_flag,
                        kernel_request_line => k2l_red_request,
                        data_out            => data_out_red,
                        data_out_flag       => red_flag,
                        line_request        => line_request,
                        data_mem            => data_mem_red,
                        data_mem_flag       => data_mem_flag,
                        kernel_request_mem  => k2m_red_request,
                        k_buff              => k_buff_red,
                        k_buff_flag         => red_buff_flag,
                        conv_request        => conv_request
                    );
        
    green_kernel: kernel_buff
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        k_row               => k_row,
                        k_column            => k_column,
                        resize_line         => resize_line,
                        data_line           => data_line_green,
                        data_line_flag      => data_line_flag,
                        kernel_request_line => k2l_green_request,
                        data_out            => data_out_green,
                        data_out_flag       => green_flag,
                        line_request        => line_request,
                        data_mem            => data_mem_green,
                        data_mem_flag       => data_mem_flag,
                        kernel_request_mem  => k2m_green_request,
                        k_buff              => k_buff_green,
                        k_buff_flag         => green_buff_flag,
                        conv_request        => conv_request
                    );
                    
    blue_kernel: kernel_buff
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        k_row               => k_row,
                        k_column            => k_column,
                        resize_line         => resize_line,
                        data_line           => data_line_blue,
                        data_line_flag      => data_line_flag,
                        kernel_request_line => k2l_blue_request,
                        data_out            => data_out_blue,
                        data_out_flag       => blue_flag,
                        line_request        => line_request,
                        data_mem            => data_mem_blue,
                        data_mem_flag       => data_mem_flag,
                        kernel_request_mem  => k2m_blue_request,
                        k_buff              => k_buff_blue,
                        k_buff_flag         => blue_buff_flag,
                        conv_request        => conv_request
                    );
    
    --process combines each request from kernel to line buffer into one
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            kernel_request_line <= '0';
        else
            kernel_request_line <= k2l_red_request and k2l_green_request and k2l_blue_request;
        end if;
    end process;
    
    --process combines each flag of data sent to line buffer into one
    process
    begin
        --wait until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            data_out_flag <= '0';
        else
            data_out_flag <= red_flag and green_flag and blue_flag;
        end if;
    end process;
    
    --process combines each request from kernel to memory into one
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            kernel_request_mem <= '0';
        else
            kernel_request_mem <= k2m_red_request and k2m_green_request and k2m_blue_request;
        end if; 
    end process;
    
    --process combines each flag of data sent to convolution into one
    process
    begin   
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            k_buff_flag <= '0';
        else
            k_buff_flag <= red_buff_flag and green_buff_flag and blue_buff_flag;
        end if;
    end process;

end rtl;
