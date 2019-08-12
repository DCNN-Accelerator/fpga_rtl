----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2019 10:48:28 AM
-- Design Name: 
-- Module Name: mux_1x7 - rtl
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


entity mux_1x7 is
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
end mux_1x7;

architecture rtl of mux_1x7 is

begin

    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            val_out <= (others => '0');
        else
            case (sel) is
                when 0 =>
                    val_out <= val_in_list(7 downto 0);
                when 1 =>
                    val_out <= val_in_list(15 downto 8);
                when 2 =>
                    val_out <= val_in_list(23 downto 16);
                when 3 =>
                    val_out <= val_in_list(31 downto 24);
                when 4 =>
                    val_out <= val_in_list(39 downto 32);
                when 5 =>
                    val_out <= val_in_list(47 downto 40);
                when 6 =>
                    val_out <= val_in_list(55 downto 48);
                when others =>
                    val_out <= (others => '0');
            end case;
        end if;
    end process;

end rtl;
