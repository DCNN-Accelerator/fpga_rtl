----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2019 01:28:34 PM
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
                
                --kernel values, assumes 8x8 matrix and 2's complement values -8 to 7
                k_vals_red              : in    std_logic_vector(255 downto 0);
                k_vals_green            : in    std_logic_vector(255 downto 0);
                k_vals_blue             : in    std_logic_vector(255 downto 0);
                
                --kernel buffer
                k_buff_red              : in    std_logic_vector(511 downto 0);
                k_buff_green            : in    std_logic_vector(511 downto 0);
                k_buff_blue             : in    std_logic_vector(511 downto 0);
                --signal that k_buff is ready
                k_buff_ready            : in    std_logic;
                
                --output from each matrix
                o_red                   : out   std_logic_vector(17 downto 0);
                o_green                 : out   std_logic_vector(17 downto 0);
                o_blue                  : out   std_logic_vector(17 downto 0);
                --signal that full convolution has happened
                o_done                  : out   std_logic
            );
end convolution;

architecture rtl of convolution is

--data latched in 
signal red_vals             : std_logic_vector(255 downto 0);
signal green_vals           : std_logic_vector(255 downto 0);
signal blue_vals            : std_logic_vector(255 downto 0);
signal red_buff             : std_logic_vector(511 downto 0);
signal green_buff           : std_logic_vector(511 downto 0);
signal blue_buff            : std_logic_vector(511 downto 0);
--sum of matrix multiplication
signal sum_red              : signed(17 downto 0);
signal sum_green            : signed(17 downto 0);
signal sum_blue             : signed(17 downto 0);
--flag for reading kernel buff
signal k_buff_flag          : std_logic;
--temporary signal of o_done
signal done                 : std_logic;
--used to show if there is an open multiply spot
signal red_done             : std_logic;
signal green_done           : std_logic;
signal blue_done            : std_logic;


begin

    --process handles convolution 
    process
    begin
        --waits for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            red_vals <= (others => '0');
            green_vals <= (others => '0');
            blue_vals <= (others => '0');
            red_buff <= (others => '0');
            green_buff <= (others => '0');
            blue_buff <= (others => '0');
            k_buff_flag <= '1';
        else
            --check to see if kernel buff is new
            if(k_buff_ready = '1') then
                --checks to make sure it is new data
                if(k_buff_flag = '1') then
                    --set flag to low so no new data latches in
                    k_buff_flag <= '0';
                    --latch in data
                    red_vals <= k_vals_red;
                    green_vals <= k_vals_green;
                    blue_vals <= k_vals_blue;
                    red_buff <= k_buff_red;
                    green_buff <= k_buff_green;
                    blue_buff <= k_buff_blue;
                end if;
            else
                --k_buff_ready went low so reset flag to read data on next k_buff_ready
                k_buff_flag <= '1';
            end if;
        end if;
    end process;
    
    --process handles multiplication
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            sum_red <= (others => '0');
            sum_green <= (others => '0');
            sum_blue <= (others => '0');
            o_red <= (others => '0');
            o_green <= (others => '0');
            o_blue <= (others => '0');
            done <= '0';
            o_done <= '0';
            red_done <= '0';
            green_done <= '0';
            blue_done <= '0';
        else
            --have o_done mimic done
            o_done <= done;
            
            --check to see if it is not done and new data was entered
            if(done = '0' and k_buff_flag = '0') then
                --checks to see if either of the vectors are equal to 0
                if(unsigned(red_vals) = 0 or unsigned(red_buff) = 0) then
                    red_done <= '1';
                end if;
                if(unsigned(green_vals) = 0 or unsigned(green_buff) = 0) then
                    green_done <= '1';
                end if;
                if(unsigned(blue_vals) = 0 or unsigned(blue_buff) = 0) then
                    blue_done <= '1';
                end if;
                
                --assigns done to the and of all the colors being done
                done <= red_done and green_done and blue_done;
                
                --checks to see if any are done
                --use the '1' & rgb_buff to convert from postive to 2's comp positive
                --rgb_vals should already be in 2's complement
                if(red_done = '1') then
                    if(green_done = '1') then
                        if(blue_done = '0') then 
                            --red and green are done, do 3 blue multiplications
                            sum_blue <= signed(sum_blue) + signed(blue_vals(3 downto 0)) * signed('1' & blue_buff(7 downto 0)) + signed(blue_vals(7 downto 4)) * signed('1' & blue_buff(15 downto 8)) + signed(blue_vals(11 downto 8)) * signed('1' & blue_buff(23 downto 16));
                            --shift by 3 values
                            blue_vals(243 downto 0) <= blue_vals(255 downto 12);
                            blue_vals(255 downto 244) <= (others => '0');
                            blue_buff(487 downto 0) <= blue_buff(511 downto 24);
                            blue_buff(511 downto 488) <= (others => '0');
                        end if;
                    else
                        if(blue_done = '1') then
                            --red and blue are done, do 3 green multiplications
                            sum_green <= signed(sum_green) + signed(green_vals(3 downto 0)) * signed('1' & green_buff(7 downto 0)) + signed(green_vals(7 downto 4)) * signed('1' & green_buff(15 downto 8)) + signed(green_vals(11 downto 8)) * signed('1' & green_buff(23 downto 16));
                            --shift by 3 values
                            green_vals(243 downto 0) <= green_vals(255 downto 12);
                            green_vals(255 downto 244) <= (others => '0');
                            green_buff(487 downto 0) <= green_buff(511 downto 24);
                            green_buff(511 downto 288) <= (others => '0');
                        else
                            --only red is done, do 2 green multiplications and 1 blue
                            sum_green <= signed(sum_green) + signed(green_vals(3 downto 0)) * signed('1' & green_buff(7 downto 0)) + signed(green_vals(7 downto 4)) * signed('1' & green_buff(15 downto 8));
                            --shift by 2 values
                            green_vals(247 downto 0) <= green_vals(255 downto 8);
                            green_vals(255 downto 248) <= (others => '0');
                            green_buff(495 downto 0) <= green_buff(511 downto 16);
                            green_buff(511 downto 296) <= (others => '0');
                            
                            sum_blue <= signed(sum_blue) + signed(blue_vals(3 downto 0)) * signed('1' & blue_buff(7 downto 0));
                            --shift by 1 value
                            blue_vals(251 downto 0) <= blue_vals(255 downto 4);
                            blue_vals(255 downto 252) <= (others => '0');
                            blue_buff(503 downto 0) <= blue_buff(511 downto 8);
                            blue_buff(511 downto 504) <= (others => '0');
                        end if;
                    end if;
                else
                    if(green_done = '1') then
                        if(blue_done = '1') then
                            --green and blue are done, do 3 red multiplications
                            sum_red <= signed(sum_red) + signed(red_vals(3 downto 0)) * signed('1' & red_buff(7 downto 0)) + signed(red_vals(7 downto 4)) * signed('1' & red_buff(15 downto 8)) + signed(red_vals(11 downto 8)) * signed('1' & red_buff(23 downto 16));
                            --shift by 3 values
                            red_vals(243 downto 0) <= red_vals(255 downto 12);
                            red_vals(255 downto 244) <= (others => '0');
                            red_buff(487 downto 0) <= red_buff(511 downto 24);
                            red_buff(511 downto 288) <= (others => '0');
                        else
                            --only green is done, do 2 red multiplications and 1 blue
                            sum_red <= signed(sum_red) + signed(red_vals(3 downto 0)) * signed('1' & red_buff(7 downto 0)) + signed(red_vals(7 downto 4)) * signed('1' & red_buff(15 downto 8));
                            --shift by 2 values
                            red_vals(247 downto 0) <= red_vals(255 downto 8);
                            red_vals(255 downto 248) <= (others => '0');
                            red_buff(495 downto 0) <= red_buff(511 downto 16);
                            red_buff(511 downto 296) <= (others => '0');
                            
                            sum_blue <= signed(sum_blue) + signed(blue_vals(3 downto 0)) * signed('1' & blue_buff(7 downto 0));
                            --shift by 1 value
                            blue_vals(251 downto 0) <= blue_vals(255 downto 4);
                            blue_vals(255 downto 252) <= (others => '0');
                            blue_buff(503 downto 0) <= blue_buff(511 downto 8);
                            blue_buff(511 downto 504) <= (others => '0');
                        end if;
                    else
                        if(blue_done = '1') then
                            --only green is done, do 2 red multiplications and 1 blue
                            sum_red <= signed(sum_red) + signed(red_vals(3 downto 0)) * signed('1' & red_buff(7 downto 0)) + signed(red_vals(7 downto 4)) * signed('1' & red_buff(15 downto 8));
                            --shift by 2 values
                            red_vals(247 downto 0) <= red_vals(255 downto 8);
                            red_vals(255 downto 248) <= (others => '0');
                            red_buff(495 downto 0) <= red_buff(511 downto 16);
                            red_buff(511 downto 296) <= (others => '0');
                            
                            sum_green <= signed(sum_green) + signed(green_vals(3 downto 0)) * signed('1' & green_buff(7 downto 0));
                            --shift by 1 value
                            green_vals(251 downto 0) <= green_vals(255 downto 4);
                            green_vals(255 downto 252) <= (others => '0');
                            green_buff(503 downto 0) <= green_buff(511 downto 8);
                            green_buff(511 downto 504) <= (others => '0');
                        else
                            --none are done, do 1 of each
                            sum_red <= signed(sum_red) + signed(red_vals(3 downto 0)) * signed('1' & red_buff(7 downto 0));
                            --shift by 1 value
                            red_vals(251 downto 0) <= red_vals(255 downto 4);
                            red_vals(255 downto 252) <= (others => '0');
                            red_buff(503 downto 0) <= red_buff(511 downto 8);
                            red_buff(511 downto 504) <= (others => '0');
                                                        
                            sum_green <= signed(sum_green) + signed(green_vals(3 downto 0)) * signed('1' & green_buff(7 downto 0));
                            --shift by 1 value
                            green_vals(251 downto 0) <= green_vals(255 downto 4);
                            green_vals(255 downto 252) <= (others => '0');
                            green_buff(503 downto 0) <= green_buff(511 downto 8);
                            green_buff(511 downto 504) <= (others => '0');
                            
                            sum_blue <= signed(sum_blue) + signed(blue_vals(3 downto 0)) * signed('1' & blue_buff(7 downto 0));
                            --shift by 1 value
                            blue_vals(251 downto 0) <= blue_vals(255 downto 4);
                            blue_vals(255 downto 252) <= (others => '0');
                            blue_buff(503 downto 0) <= blue_buff(511 downto 8);
                            blue_buff(511 downto 504) <= (others => '0');
                        end if;
                    end if;
                end if;
            else
                --checks to see if it is done
                if(done = '1') then
                    --save all the outputs
                    o_red <= std_logic_vector(sum_red);
                    o_green <= std_logic_vector(sum_green);
                    o_blue <= std_logic_vector(sum_blue);
                end if;
                
                --checks to see if it should reset done
                if(k_buff_flag = '1') then
                    done <= '0';
                end if;
            end if;
        end if;
    end process;

end rtl;
