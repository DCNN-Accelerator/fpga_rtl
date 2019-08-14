----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2019 08:56:34 AM
-- Design Name: 
-- Module Name: kernel_vals_rgb - rtl
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


entity kernel_vals_rgb is
    PORT    (
                clk                 : in    std_logic;
                rst                 : in    std_logic;
                softreset           : in    std_logic;
                
                --new kernel filter values
                data_in             : in    std_logic_vector(23 downto 0);
                data_in_flag        : in    std_logic;
                
                --output of the kernel filter values
                data_out_red        : out   std_logic_vector(391 downto 0);
                data_out_green      : out   std_logic_vector(391 downto 0);
                data_out_blue       : out   std_logic_vector(391 downto 0)
            );
end kernel_vals_rgb;

architecture rtl of kernel_vals_rgb is

type color is (idle, red, green, blue);

--used to create the full kernel value for each color
signal filter_buff              : std_logic_vector(391 downto 0);
--used to determine which kernel_vals gets filter_buff
signal color_state              : color;
signal red_flag                 : std_logic;
signal green_flag               : std_logic;
signal blue_flag                : std_logic;
--used to determine if it should read data_in
signal wait4data                : std_logic;
--used to show that all data for filter_vals was read
signal done                     : std_logic;
--counter used for index of filter_buff
signal counter                  : integer range 0 to 16;


    component kernel_vals is
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
    end component;

begin

    red_vals: kernel_vals
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        softreset           => softreset,
                        data_in             => filter_buff,
                        data_in_flag        => red_flag,
                        data_out            => data_out_red
                    );

    green_vals: kernel_vals
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        softreset           => softreset,
                        data_in             => filter_buff,
                        data_in_flag        => green_flag,
                        data_out            => data_out_green
                    );
                    
    blue_vals: kernel_vals
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        softreset           => softreset,
                        data_in             => filter_buff,
                        data_in_flag        => blue_flag,
                        data_out            => data_out_blue
                    );
                    
    --process handles taking in data and creating filter_buff,
    --once filter_buff is full it gets passed in to one of the k_vals
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            filter_buff <= (others => '0');
            wait4data <= '0';
            done <= '0';
            counter <= 0;
        else
            --checks to see if new data was sent
            if(data_in_flag = '1') then
                --checks to make sure it isnt waiting for it to update
                if(wait4data = '0') then
                    --new data save it into filter_buff
                    --checks to make sure it isnt the last byte 
                    if(counter = 16) then
                        --save data
                        filter_buff(391 downto 384) <= data_in(7 downto 0);
                        --shift old data
                        filter_buff(383 downto 0) <= filter_buff(391 downto 8);
                        --reset counter
                        counter <= 0;
                        --change to done so it can swap colors
                        done <= '1';
                    else
                        --not last byte, so save 3 bytes at once
                        --save data
                        filter_buff(391 downto 368) <= data_in;
                        --shift old data
                        filter_buff(367 downto 0) <= filter_buff(391 downto 24);
                        --increase counter 
                        counter <= counter + 1;
                        --ensure done is low
                        done <= '0';
                    end if;
                    
                    --turn on wait4data
                    wait4data <= '1';
                else
                    --continue to wait
                    wait4data <= '1';
                    --ensure done is low
                    done <= '0';
                end if;
            else    
                --data_in_flag reset, turn wait4data off
                wait4data <= '0';
                --ensure done is low
                done <= '0';
            end if;
        end if;
    end process;

    --process turns on the necessary color flag
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0' or softreset = '0') then
            color_state <= idle;
            red_flag <= '0';
            green_flag <= '0';
            blue_flag <= '0';
        else
            if(done = '1') then
                case (color_state) is
                    --move out of idle to red, turn on red flag
                    when idle =>
                        color_state <= red;
                        red_flag <= '1';
                    
                    --move out of red to green, turn on green flag
                    when red =>
                        color_state <= green;
                        green_flag <= '1';
                    
                    --move out of green to blue, turn on blue flag
                    when green =>
                        color_state <= blue;
                        blue_flag <= '1';
                        
                    --move out of blue to idle
                    when blue =>
                        color_state <= idle;
                end case;
            else
                --is not done, turn off all flags
                red_flag <= '0';
                green_flag <= '0';
                blue_flag <= '0';
            end if;
        end if;
    end process;

end rtl;
