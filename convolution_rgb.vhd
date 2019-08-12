----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2019 11:20:37 AM
-- Design Name: 
-- Module Name: convolution_rgb - rtl
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

entity convolution_rgb is
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
end convolution_rgb;

architecture rtl of convolution_rgb is

signal red_done             : std_logic;
signal green_done           : std_logic;
signal blue_done            : std_logic;

    component convolution
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
    end component;

begin

    red: convolution
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        k_vals              => k_vals_red,
                        k_buff              => k_buff_red,
                        k_buff_ready        => k_buff_ready,
                        o_val               => o_val_red,
                        o_done              => red_done
                    );
    green: convolution 
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        k_vals              => k_vals_green,
                        k_buff              => k_buff_blue,
                        k_buff_ready        => k_buff_ready,
                        o_val               => o_val_green,
                        o_done              => green_done
                    );

    blue: convolution
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        k_vals              => k_vals_blue,
                        k_buff              => k_buff_blue,
                        k_buff_ready        => k_buff_ready,
                        o_val               => o_val_blue,
                        o_done              => blue_done
                    );    

    --process waits to mark done until each color is done
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            o_done <= '0';
        else
            o_done <= red_done and green_done and blue_done;
        end if;
    end process;

end rtl;
