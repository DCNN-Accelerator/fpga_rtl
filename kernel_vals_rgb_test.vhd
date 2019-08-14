----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2019 07:56:33 AM
-- Design Name: 
-- Module Name: kernel_vals_rgb_test - Behavioral
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


entity kernel_vals_rgb_test is
--  Port ( );
end kernel_vals_rgb_test;

architecture rtl of kernel_vals_rgb_test is

signal clk_100              : std_logic := '0';
signal rst_100              : std_logic := '0';
signal softreset_100        : std_logic := '1';

signal filter_data          : std_logic_vector(23 downto 0) := (others => '0');
signal filter_flag          : std_logic := '0';
signal red_filter           : std_logic_vector(391 downto 0) := (others => '0');
signal green_filter         : std_logic_vector(391 downto 0) := (others => '0');
signal blue_filter          : std_logic_vector(391 downto 0) := (others => '0');

signal counter              : integer := 0;
signal color                : integer := 0;
signal sim_end              : std_logic := '0';

    component kernel_vals_rgb
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
    end component;

begin

    my_filter: kernel_vals_rgb
        PORT MAP    (
                        clk                 => clk_100,
                        rst                 => rst_100,
                        softreset           => softreset_100,
                        data_in             => filter_data,
                        data_in_flag        => filter_flag,
                        data_out_red        => red_filter,
                        data_out_green      => green_filter,
                        data_out_blue       => blue_filter
                    );
                    
                    
    --process generates 100MHz clk
    process
    begin
        --if(sim_end = '0') then
            wait for 5 ns;
            clk_100 <= not clk_100;
        --end if;
    end process;
    
    --process generates initial reset
    process
    begin
        wait until clk_100 = '1';
    
        --if(sim_end = '0') then
            if(rst_100 = '0') then
                wait for 10 ns;
                rst_100 <= '1';
            end if;
        --end if;
    end process;
    
    --process handles transfering data to filter
    process
    begin
        wait until clk_100 = '1';
    
        if(softreset_100 = '1') then
            --checks to see how many colors were done
            if(color < 3 and rst_100 = '1') then
                --not all colors were done, check to see if a color just finished
                if(counter = 17) then
                    --sent 16 packets, increase colors sent
                    color <= color + 1;
                    counter <= 0;
                    
                    --wait a while before sending packets again
                    wait for 15 ns;
                else
                    --color is not done, continue to send packets
                    case counter is
                        when 0 =>
                            filter_data <= X"AABB12";
                        when 1 =>
                            filter_data <= X"A0DD11";
                        when 2 =>
                            filter_data <= X"1FFFFF";
                        when 3 =>
                            filter_data <= X"CDEE88";
                        when others =>
                            filter_data <= X"FF01" & std_logic_vector(to_unsigned(color, 8));
                    end case;
                    --increase counter
                    counter <= counter + 1;
                    wait for 20 ns;
                    filter_flag <= '1';
                    wait for 20 ns;
                    filter_flag <= '0';
                    --sim_end <= '1';
                end if;
            end if;  
        else
            counter <= 0;
            color <= 0;
        end if;
    end process;
    
    --handles soft reset to refill the filter
    process
    begin
        wait until clk_100 = '1';
        
        if(color = 3 and sim_end = '0') then
            softreset_100 <= '0';
            sim_end <= '1';
        end if;
        
        if(softreset_100 = '0') then
            softreset_100 <= '1';
        end if;
    end process;
    

end rtl;
