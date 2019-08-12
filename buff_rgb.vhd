----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2019 08:56:34 AM
-- Design Name: 
-- Module Name: buff_rgb - rtl
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buff_rgb is
    PORT    (
                clk                         : in    std_logic;
                rst                         : in    std_logic;
                softreset                   : in    std_logic;
               
                --new byte of data into buffer
                data_in_red                 : in    std_logic_vector(7 downto 0);
                data_in_green               : in    std_logic_vector(7 downto 0);
                data_in_blue                : in    std_logic_vector(7 downto 0);
                data_in_flag                : in    std_logic;
                buff_request                : out   std_logic;
               
                --kernel buffer thats sent for convolution
                --assumes 7*7 kernel thats 1 byte deep
                kernel_out_red              : out   std_logic_vector(391 downto 0);
                kernel_out_green            : out   std_logic_vector(391 downto 0);
                kernel_out_blue             : out   std_logic_vector(391 downto 0);
                kernel_out_flag             : out   std_logic;
                kernel_request              : in    std_logic
           );
end buff_rgb;

architecture rtl of buff_rgb is

--used to make all requests happen at the same time
signal red_request              : std_logic;
signal green_request            : std_logic;
signal blue_request             : std_logic;
--used to make all data out flags happen at the same time
signal red_flag                 : std_logic;
signal green_flag               : std_logic;
signal blue_flag                : std_logic;

    component buff is
        PORT    (
                    clk                         : in    std_logic;
                    rst                         : in    std_logic;
                    softreset                   : in    std_logic;
                    
                    --new byte of data into buffer
                    data_in                     : in    std_logic_vector(7 downto 0);
                    data_in_flag                : in    std_logic;
                    buff_request                : out   std_logic;
                    
                    --kernel buffer thats sent for convolution
                    --assumes 7*7 kernel thats 1 byte deep
                    kernel_out                  : out   std_logic_vector(391 downto 0);
                    kernel_out_flag             : out   std_logic;
                    kernel_request              : in    std_logic
                );
    end component;

begin

    red_buff: buff
        PORT MAP    (   
                        clk                     => clk,
                        rst                     => rst,
                        softreset               => softreset,
                        data_in                 => data_in_red,
                        data_in_flag            => data_in_flag,
                        buff_request            => red_request,
                        kernel_out              => kernel_out_red,
                        kernel_out_flag         => red_flag,
                        kernel_request          => kernel_request
                    );
                    
    green_buff: buff
        PORT MAP    (
                        clk                     => clk,
                        rst                     => rst,
                        softreset               => softreset,
                        data_in                 => data_in_green,
                        data_in_flag            => data_in_flag,
                        buff_request            => green_request,
                        kernel_out              => kernel_out_green,
                        kernel_out_flag         => green_flag,
                        kernel_request          => kernel_request
                    );
                    
    blue_buff: buff
        PORT MAP    (
                        clk                     => clk,
                        rst                     => rst,
                        softreset               => softreset,
                        data_in                 => data_in_blue,
                        data_in_flag            => data_in_flag,
                        buff_request            => blue_request,
                        kernel_out              => kernel_out_blue,
                        kernel_out_flag         => blue_flag,
                        kernel_request          => kernel_request
                    );
    
    --process handles combining signals from each buffer into one
    process
    begin
        --wait until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            buff_request <= '0';
            kernel_out_flag <= '0';
        else
            --checks to make sure all signals are high before changing to high
            buff_request <= red_request and green_request and blue_request;
            kernel_out_flag <= red_flag and green_flag and blue_flag;
        end if;
    end process;

end rtl;
