----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/09/2019 01:28:34 PM
-- Design Name: 
-- Module Name: convolution - rtl
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

entity convolution is
    PORT    (
                clk                     : in    std_logic;
                rst                     : in    std_logic;
                
                --kernel filter values
                k_vals                  : in    std_logic_vector(391 downto 0);
                
                --kernel buffer
                k_buff                  : in    std_logic_vector(391 downto 0);
                --signal that k_buff is ready
                k_buff_ready            : in    std_logic;
                
                --output from each matrix
                o_val                   : out   std_logic_vector(17 downto 0);
                --signal that full convolution has happened
                o_done                  : out   std_logic
            );
end convolution;

architecture rtl of convolution is

constant zeros              : std_logic_vector(391 downto 0) := (others => '0');

--sum of matrix multiplication
signal sum                  : signed(17 downto 0);
--temporary signal of o_done
signal done                 : std_logic;
--mimics o_done 
signal o_done_mimic         : std_logic;
--latched in values
signal latch_f              : std_logic_vector(391 downto 0);
signal latch_b              : std_logic_vector(391 downto 0);

begin


    
    --process handles multiplication
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            o_done <= '1';
            sum <= (others => '0');
            done <= '0';
            o_val <= (others => '0');
            o_done_mimic <= '1';
            latch_b <= (others => '0');
            latch_f <= (others => '0');
        else
        
            --checks to see if it is ready for convolution
            if(k_buff_ready = '1') then
                --checks to see if the convolution was not performed
                if(done = '0') then
                    if(o_done_mimic = '0') then
                        --checks to see if all values were calculated
                        if(latch_f = zeros or latch_b = zeros)then
                            --set done to true
                            done <= '1';
                            --set sum to output
                            o_val <= std_logic_vector(sum);
                            --reset sum
                            sum <= (others => '0');
                            --convolution is done
                            o_done <= '1';
                            o_done_mimic <= '1';
                        else
                            --convolutino started therefor no output is done
                            o_done <= '0';
                            o_done_mimic <= '0';
                            --shift in 0's to value read
                            latch_f(391 downto 384) <= X"00";
                            latch_b(391 downto 384) <= X"00";
                            --shift old data
                            latch_f(383 downto 0) <= latch_f(391 downto 8);
                            latch_b(383 downto 0) <= latch_b(391 downto 8);
                            --continue to perform convolution
                            sum <= sum + signed(latch_f(7 downto 0)) * signed('0' & latch_b(7 downto 0));
                        end if;
                    
                    else
                        o_done <= '0';
                        o_done_mimic <= '0';
                        latch_f <= k_vals;
                        latch_b <= k_buff;
                    end if;
                else
                    --continue to wait for k_buff_ready is reset
                    done <= '1';
                end if;
            else
                --k_buff_ready was reset, allow next convolution
                done <= '0';
                sum <= (others => '0');
            end if;
        end if;
    end process;

end rtl;
