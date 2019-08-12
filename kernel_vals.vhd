----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2019 08:56:34 AM
-- Design Name: 
-- Module Name: kernel_vals - rtl
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

entity kernel_vals is
    PORT    (
            clk                 : in    std_logic;
            rst                 : in    std_logic;
            softreset           : in    std_logic;
            
            --new kernel filter values
            data_in             : in    std_logic_vector(391 downto 0);
            data_in_flag        : in    std_logic;
            
            --output of the kernel filter values
            data_out            : out   std_logic_vector(391 downto 0)
        );
end kernel_vals;

architecture rtl of kernel_vals is

begin

    --checks to see if new data is avaible
    process
    begin
        --wait until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            data_out <= (others => '0');
        else
            if(softreset = '0') then
                data_out <= (others => '0');
            else
                --checks to see if new data was sent
                if(data_in_flag = '1') then
                    --new data so change output
                    data_out <= data_in;
                end if;
            end if;
        end if;
    end process;

end rtl;
