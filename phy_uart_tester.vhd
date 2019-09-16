----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2019 05:58:54 PM
-- Design Name: 
-- Module Name: phy_uart_tester - rtl
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

entity phy_uart_tester is
    PORT    (
                clk                 : in    std_logic;
                rst                 : in    std_logic;
                
                read                : out   std_logic;
                read_data           : in    std_logic_vector(7 downto 0);
                read_ready          : in    std_logic;
                
                write               : out   std_logic;
                write_data          : out   std_logic_vector(7 downto 0);
                write_full          : in    std_logic
            );
end phy_uart_tester;

architecture rtl of phy_uart_tester is

type my_states is (i, r, w);

signal state        : my_states;

begin

    process
    begin
        --wait for rising edge of clk
        wait until clk = '1';
        
        if (rst = '0') then
            state <= i;
            read <= '0';
            write <= '0';
            write_data <= (others => '0');
        else
            case state is
                when i =>
                    if( read_ready = '1') then
                        state <= r;
                        read <= '1';
                    else
                        read <= '0';
                        state <= i;
                    end if;
                    
                when r =>
                    read <= '0';
                    write_data <= read_data;
                    state <= w;
                    
                when w =>
                    if(write_full = '0') then
                        write <= '1';
                        state <= i;
                    else
                        write <= '0';
                        state <= w;
                    end if;
                    
                when others =>
                    state <= i;
            end case;
        end if;
    
    end process;

end rtl;
