----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2019 09:37:52 AM
-- Design Name: 
-- Module Name: convolution_rgb_test - rtl
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


entity convolution_rgb_test is
--  Port ( );
end convolution_rgb_test;

architecture rtl of convolution_rgb_test is

signal clk_100                  : std_logic := '0';
signal rst_100                  : std_logic := '0';
signal f_red                    : std_logic_vector(391 downto 0) := (others => '0');
signal f_green                  : std_logic_vector(391 downto 0) := (others => '0');
signal f_blue                   : std_logic_vector(391 downto 0) := (others => '0');
signal b_red                    : std_logic_vector(391 downto 0) := (others => '0');
signal b_green                  : std_logic_vector(391 downto 0) := (others => '0');
signal b_blue                   : std_logic_vector(391 downto 0) := (others => '0');
signal b_ready                  : std_logic := '0';
signal o_red                    : std_logic_vector(17 downto 0);
signal o_green                  : std_logic_vector(17 downto 0);
signal o_blue                   : std_logic_vector(17 downto 0);
signal o_done                   : std_logic; 

signal temp                     : std_logic := '0';

    component convolution_rgb
        PORT    (
                clk                     : in    std_logic;
                rst                     : in    std_logic;
                
                --kernel filter values
                k_vals_red              : in    std_logic_vector(391 downto 0);
                k_vals_green            : in    std_logic_vector(391 downto 0);
                k_vals_blue             : in    std_logic_vector(391 downto 0);
                
                --kernel buffer
                k_buff_red              : in    std_logic_vector(391 downto 0);
                k_buff_green            : in    std_logic_vector(391 downto 0);
                k_buff_blue             : in    std_logic_vector(391 downto 0);
                --signal that k_buff is ready
                k_buff_ready            : in    std_logic;
                
                --output from each matrix
                o_val_red               : out   std_logic_vector(17 downto 0);
                o_val_green             : out   std_logic_vector(17 downto 0);
                o_val_blue              : out   std_logic_vector(17 downto 0);
                --signal that full convolution has happened
                o_done                  : out   std_logic
            );
    end component;

begin

    my_conv: convolution_rgb
        PORT MAP    (
                        clk                 => clk_100,
                        rst                 => rst_100,
                        k_vals_red          => f_red,
                        k_vals_green        => f_green,
                        k_vals_blue         => f_blue,
                        k_buff_red          => b_red,
                        k_buff_green        => b_green,
                        k_buff_blue         => b_blue,
                        k_buff_ready        => b_ready,
                        o_val_red           => o_red,
                        o_val_green         => o_green, 
                        o_val_blue          => o_blue,
                        o_done              => o_done
                    );
    
    --generates 100MHz clock
    process
    begin
        wait for 5 ns;
        clk_100 <= not clk_100;
    end process;
    
    --generates intial reset
    process
    begin
        wait until clk_100 = '1';
        
        if(rst_100 = '0') then
            rst_100 <= '1';
            
            --create filter for -8 in every box
            for i in 0 to 48 loop
                f_red((i + 1) * 8 - 1 downto i * 8) <= "11111000";
                f_green((i + 1) * 8 - 1 downto i * 8) <= "11111000";
                f_blue((i + 1) * 8 - 1 downto i * 8) <= "11111000";            
                b_red((i + 1) * 8 - 1 downto i * 8) <= "10101010";
            end loop;
            
            b_blue <= not b_blue;
        end if;
    end process;
    
    process
    begin
        wait until clk_100 = '1';
        
        if(rst_100 = '1') then
            if(o_done = '1') then
                b_ready <= '1';
                
                temp <= '1';
            else
                
            end if;
        end if;
    end process;
    
end rtl;
