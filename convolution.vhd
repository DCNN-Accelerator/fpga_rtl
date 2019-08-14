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

--sum of matrix multiplication
signal sum                  : signed(17 downto 0);
--temporary signal of o_done
signal done                 : std_logic;
--countered used to determine which index of values to use for multiplication
signal row                  : integer range 0 to 7;
signal col                  : integer range 0 to 6;
--used for actual multiplicatino
signal filter_byte          : std_logic_vector(7 downto 0);
signal buff_byte            : std_logic_vector(7 downto 0);

    component mux_7x7
        PORT    (
                    clk                 : in    std_logic;
                    rst                 : in    std_logic;
                    
                    --used to select which of the 49 values to use
                    row                 : in    integer range 0 to 6;
                    col                 : in    integer range 0 to 6;
                    
                    --list of all 49 values, each 1 byte long
                    val_in_list         : in    std_logic_vector(391 downto 0);
                    
                    --output value from the mux
                    val_out             : out   std_logic_vector(7 downto 0)
                );
    end component;

begin

    filter_mux: mux_7x7
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        row             => row,
                        col             => col,
                        val_in_list     => k_vals,
                        val_out         => filter_byte
                    );
                    
    buff_mux: mux_7x7
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        row             => row,
                        col             => col,
                        val_in_list     => k_buff,
                        val_out         => buff_byte
                    );
    
    --process handles multiplication
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            row <= 0;
            col <= 0;
            o_done <= '1';
            sum <= (others => '0');
            done <= '0';
            o_val <= (others => '0');
        else
        
            --checks to see if it is ready for convolution
            if(k_buff_ready = '1') then
                --checks to see if the convolution was not performed
                if(done = '0') then
                    --checks to see if all values were calculated
                    if(row = 7) then
                        --set done to true
                        done <= '1';
                        --set sum to output
                        o_val <= std_logic_vector(sum);
                        --reset sum
                        sum <= (others => '0');
                        --reset counter
                        row <= 0;
                        col <= 0;
                        --convolution is done
                        o_done <= '1';
                    else
                        --convolution beginning so reset done
                        o_done <= '0';
                        --increase counter
                        if(col = 6) then
                            col <= 0;
                            row <= row + 1;
                        else
                            col <= col + 1;
                        end if;
                        --continue to perform convolution
                        sum <= sum + signed(filter_byte) * signed('0' & buff_byte);
                    end if;
                else
                    --continue to wait for k_buff_ready is reset
                    done <= '1';
                end if;
            else
                --k_buff_ready was reset, allow next convolution
                done <= '0';
                sum <= (others => '0');
                row <= 0;
                col <= 0;
            end if;
        end if;
    end process;

end rtl;
