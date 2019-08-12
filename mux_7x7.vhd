----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2019 10:01:34 AM
-- Design Name: 
-- Module Name: mux_7x7 - rtl
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


entity mux_7x7 is
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
end mux_7x7;

architecture rtl of mux_7x7 is

signal row0_out             : std_logic_vector(7 downto 0);
signal row1_out             : std_logic_vector(7 downto 0);
signal row2_out             : std_logic_vector(7 downto 0);
signal row3_out             : std_logic_vector(7 downto 0);
signal row4_out             : std_logic_vector(7 downto 0);
signal row5_out             : std_logic_vector(7 downto 0);
signal row6_out             : std_logic_vector(7 downto 0);

    component mux_1x7  is
        PORT    (
                clk                 : in    std_logic;
                rst                 : in    std_logic;
                
                --used to select which of the 7 values to use
                sel                 : in    integer range 0 to 6;
                
                --list of all 49 values, each 1 byte long
                val_in_list         : in    std_logic_vector(55 downto 0);
                
                --output value from the mux
                val_out             : out   std_logic_vector(7 downto 0)
            );
    end component;

begin
    
    row0: mux_1x7
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        sel                 => col,
                        val_in_list         => val_in_list(55 downto 0),
                        val_out             => row0_out
                    );
    row1: mux_1x7
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        sel                 => col,
                        val_in_list         => val_in_list(111 downto 56),
                        val_out             => row1_out
                    );
                    
    row2: mux_1x7
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        sel                 => col,
                        val_in_list         => val_in_list(167 downto 112),
                        val_out             => row2_out
                    );
                    
    row3: mux_1x7
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        sel                 => col,
                        val_in_list         => val_in_list(223 downto 168),
                        val_out             => row3_out
                    );
                    
    row4: mux_1x7
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        sel                 => col,
                        val_in_list         => val_in_list(279 downto 224),
                        val_out             => row4_out
                    );
                    
    row5: mux_1x7
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        sel                 => col,
                        val_in_list         => val_in_list(335 downto 280),
                        val_out             => row5_out
                    );
    
    row6: mux_1x7
        PORT MAP    (
                        clk                 => clk,
                        rst                 => rst,
                        sel                 => col,
                        val_in_list         => val_in_list(391 downto 336),
                        val_out             => row6_out
                    );
                    
    --handles entire mux operation
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            val_out <= (others => '0');
        else
            case (row) is
                when 0 =>
                    val_out <= row0_out;
                when 1 => 
                    val_out <= row1_out;
                when 2 =>
                    val_out <= row2_out;
                when 3 =>
                    val_out <= row3_out;
                when 4 => 
                    val_out <= row4_out;
                when 5 =>
                    val_out <= row5_out;
                when 6 =>
                    val_out <= row6_out;
                when others =>
                    val_out <= (others => '0');
            end case;
        end if;
    end process;

end rtl;
