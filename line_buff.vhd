----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2019 01:28:34 PM
-- Design Name: 
-- Module Name: line_buff - rtl
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

entity line_buff is
    PORT    (
                clk                     : in    std_logic;
                rst                     : in    std_logic;
                
                --amount of pixel rows in the line buffer, MAX amount of rows is 7
                row                     : in    integer range 0 to 7;
                --amount of pixel columns in the line buffer, MAX amount of columns is 4096
                column                  : in    integer range 0 to 4096;
                --kernel length of columns, assumes max kernel size is 8x8
                k_column                : in    integer range 0 to 8;
                --signal that shows either row or column changed. Can also be used as a soft reset
                resize_line             : in    std_logic;
                
                --new data to be placed in line buffer
                data_in                 : in    std_logic_vector(7 downto 0);
                --flag for when new data is ready to be read in
                data_in_flag            : in    std_logic;
                --line request more data
                line_request            : out   std_logic;
                
                --data sent to the kernel buffer, assumes MAX kernel is 8x8
                data_out                : out   std_logic_vector(55 downto 0);
                --flag for when kernel buffer should read in data_out
                data_out_flag           : out   std_logic;
                --kernel request more data
                kernel_request          : in    std_logic;
                
                --flag when line_buff is full
                full                    : out   std_logic
            );
end line_buff;

architecture rtl of line_buff is

subtype byte_type is std_logic_vector(7 downto 0);
--make linebuffer size equal to amount of rows * columns
type byte_line is array(integer range 0 to (7 * 4096 - 1)) of byte_type;

--flag for when size has changed
signal size_flag            : std_logic;
--buffer of data
signal buff                 : byte_line;
--temporary of line_request
signal request              : std_logic;
--counter to determine when the line_buff is full
signal counter              : integer range 0 to 7 * 4096;
--temp byte used to hold new data in to write after old data has been shifted
signal temp_byte            : std_logic_vector(7 downto 0);

begin
    
    --process handles calculating the size of the line buffer
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            size_flag <= '1';
        else
            --if size_flag is active, row or column changed in length
            if(size_flag <= '1') then
                size_flag <= '0';
            end if;
            
            --checks to see if a resize happened
            if(resize_line = '1') then
                size_flag <= '1';
            end if;
        end if;
    end process;
    
    --process determines if the line buffer is full
    process
    begin
        --waits for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            full <= '0';
        else
            --determines if it should display full
            if(counter = (row * column - 1) and counter /= 0) then
                full <= '1';
            else
                full <= '0';
            end if;
        end if;
    end process;
    
    --handles inputting new data onto line buffer
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            buff <= (others => (others => '0'));
            request <= '0';
            line_request <= '0';
            counter <= 0;
        else
            --have line_request mimic request
            line_request <= request;
            
            --checks to see if the size_flag has been activated
            if(size_flag <= '1') then
                --size changed so reset buffer
                buff <= (others => (others => '0'));
                --set request to no
                request <= '0';
                --reset counter 
                counter <= 0;
            else
                --checks to see if it is requesting data
                if(request <= '1') then
                    --checks to see if data_in_flag is set
                    if(data_in_flag = '1') then
                        --received new data, set request to no
                        request <= '0';
                        --read in new data in the last usable space in the line buffer
                        temp_byte <= data_in;
                        --shift all old data
                        buff(((7 * 4096 - 1) - 1) downto 0) <= buff((7 * 4096 - 1) downto 1);
                        --byte was recived, increment counter
                        if(counter < (row * column - 1)) then
                            counter <= counter + 1;
                        end if;
                    else
                        --requesting data still
                        request <= '1';
                    end if;
                else
                    --while not requesting data, update the new data read in into line buffer
                    buff(row * column - 1) <= temp_byte;
                    --checks to see if data_in_flag has been reset
                    if(data_in_flag = '0') then
                        --can request agian
                        request <= '1';
                    else
                        --waiting for flag to reset
                        request <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    --handles outputting data to kernel buffer
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            data_out <= (others => '0');
            data_out_flag <= '0';
        else
            --checks to see if kernel is ready for new data
            if(kernel_request = '1') then
                --row of kernel needs buffer offset by the kernel size plus size of buffer columns
                data_out(7 downto 0) <= buff(k_column);
                data_out(15 downto 8) <= buff(k_column + column);
                data_out(23 downto 16) <= buff(k_column + (column * 2));
                data_out(31 downto 24) <= buff(k_column + (column * 3));
                data_out(39 downto 32) <= buff(k_column + (column * 4));
                data_out(47 downto 40) <= buff(k_column + (column * 5));
                data_out(55 downto 48) <= buff(k_column + (column * 6));
                
                --set the flag of data_ready to true
                data_out_flag <= '1';
            else
                --kernel not ready so turn off flag
                data_out_flag <= '0';
            end if;
        end if;
    end process;

end rtl;
