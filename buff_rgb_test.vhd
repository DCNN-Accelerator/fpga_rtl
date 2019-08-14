----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2019 08:59:03 AM
-- Design Name: 
-- Module Name: buff_rgb_test - rtl
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

entity buff_rgb_test is
--  Port ( );
end buff_rgb_test;

architecture rtl of buff_rgb_test is

signal clk_100              : std_logic := '0';
signal rst_100              : std_logic := '0';
signal softreset_100        : std_logic := '1';
signal red_data             : std_logic_vector(7 downto 0) := X"00";
signal green_data           : std_logic_vector(7 downto 0) := X"00";
signal blue_data            : std_logic_vector(7 downto 0) := X"00";
signal data_flag            : std_logic := '0';
signal b_request            : std_logic;

signal k_red                : std_logic_vector(391 downto 0);
signal k_green              : std_logic_vector(391 downto 0);
signal k_blue               : std_logic_vector(391 downto 0);
signal k_flag               : std_logic;
signal k_request            : std_logic := '0'; 

signal counter              : integer := 0;

    component buff_rgb
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
    end component;

begin

    my_buff: buff_rgb
        PORT MAP    (
                        clk                 => clk_100,
                        rst                 => rst_100,
                        softreset           => softreset_100,
                        data_in_red         => red_data,
                        data_in_green       => green_data,
                        data_in_blue        => blue_data,
                        data_in_flag        => data_flag,
                        buff_request        => b_request,
                        kernel_out_red      => k_red,
                        kernel_out_green    => k_green,
                        kernel_out_blue     => k_blue,
                        kernel_out_flag     => k_flag,
                        kernel_request      => k_request
                    );
                    
    --generates 100MHz clk
    process
    begin
        wait for 5 ns;
        clk_100 <= not clk_100;
    end process;
    
    --generates initial reset
    process
    begin
        wait until clk_100 = '1';
        
        if(rst_100 = '0') then
            rst_100 <= '1';
        end if; 
    end process;
    
    --handles data transfer into buffer
    process
    begin
        wait until clk_100 = '1';
        
        if(rst_100 = '1') then
            if(data_flag = '0' and b_request = '1') then
                red_data <= std_logic_vector(to_unsigned(counter, 8));
                green_data <= std_logic_vector(to_signed(counter + 1, 8));
                blue_data <= std_logic_vector(to_unsigned(counter + 2, 8));
                data_flag <= '1';
                counter <= counter + 1;
            else
                data_flag <= '0';
            end if;
        end if;
    end process;
    
    --handles request for kernel
    process
    begin
        wait until clk_100 = '1';
        
        if(rst_100 = '1') then
            k_request <= not k_flag;
        end if;
    end process;

end rtl;
