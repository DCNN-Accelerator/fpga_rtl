----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/12/2019 08:12:06 AM
-- Design Name: 
-- Module Name: buff - rtl
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

entity buff is
    PORT    (
                clk                         : in    std_logic;
                rst                         : in    std_logic;
                softreset                   : in    std_logic;
                
                --new byte of data into buffer
                data_in                     : in    std_logic_vector(7 downto 0);
                data_in_flag                : in    std_logic;
                buff_request                : out   std_logic;
                
                --kernel buffer thats sent for convolution
                --assumes 7*7 kernel thats 1 byte deep
                kernel_out                  : out   std_logic_vector(391 downto 0);
                kernel_out_flag             : out   std_logic;
                kernel_request              : in    std_logic
            );
end buff;

architecture rtl of buff is

--create an type of a byte
subtype byte_type is std_logic_vector(7 downto 0);
--create a type of an array of bytes
--size is equal to 4096 * 6 for line buffer plus 7 for last row of kernel buffer
type byte_line is array(integer range 0 to 24582) of byte_type;

--entire buffer that is the line buffer and kernel buffer together
signal my_buff                  : byte_line;
--temporary signal for buff_request
signal my_request               : std_logic;


begin

    --looks to see if it should read in more data
    process
    begin
        --wait for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            buff_request <= '1';
            my_buff <= (others => (others => '0'));
            my_request <= '1';
        else
            --set buff_request to mimic my_request
            buff_request <= my_request;
            
            --checks to see if  the buffer should be cleared
            if(softreset = '0') then
                my_buff <= (others => (others => '0'));
                my_request <= '1';
            else
                --check to see if requesting data
                if(my_request = '1') then
                    --check to see if new data was sent
                    if(data_in_flag = '1') then
                        --save new data
                        my_buff(24582) <= data_in;
                        --shift old data
                        my_buff(0 to 24581) <= my_buff(1 to 24582);
                        --stop requesting data
                        my_request <= '0';
                    else
                        --continue to request data
                        my_request <= '1';
                    end if;
                else
                    --checks to see if data_in_flag was reset
                    if(data_in_flag = '0') then
                        --flag reset, can request again
                        my_request <= '1';
                    else
                        --flag not reset, dont request new data yet
                        my_request <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    --process looks to see if it should send out data
    process
    begin   
        --wait until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            kernel_out <= (others => '0');
            kernel_out_flag <= '0';
        else
            --checks to see if data is needed for the convolution
            if(kernel_request = '1') then
                --needs new data, send out kernel data
                --first row
                kernel_out(55 downto 0) <= my_buff(6) & my_buff(5) & my_buff(4) & my_buff(3) & my_buff(2) & my_buff(1) & my_buff(0);
                --second row
                kernel_out(111 downto 56) <= my_buff(4102) & my_buff(4101) & my_buff(4100) & my_buff(4099) & my_buff(4098) & my_buff(4097) & my_buff(4096);
                --third row
                kernel_out(167 downto 112) <= my_buff(8198) & my_buff(8197) & my_buff(8196) & my_buff(8195) & my_buff(8194) & my_buff(8193) & my_buff(8192);
                --fourth row
                kernel_out(223 downto 168) <= my_buff(12294) & my_buff(12293) & my_buff(12292) & my_buff(12291) & my_buff(12290) & my_buff(12289) & my_buff(12288);
                --fifth row
                kernel_out(279 downto 224) <= my_buff(16390) & my_buff(16389) & my_buff(16388) & my_buff(16387) & my_buff(16386) & my_buff(16385) & my_buff(16384);
                --sixth row
                kernel_out(335 downto 280) <= my_buff(20486) & my_buff(20485) & my_buff(20484) & my_buff(20483) & my_buff(20482) & my_buff(20481) & my_buff(20480);
                --seventh row
                kernel_out(391 downto 336) <= my_buff(24582) & my_buff(24581) & my_buff(24580) & my_buff(24579) & my_buff(24578) & my_buff(24577) & my_buff(24576);
                
                --set flag for data sent
                kernel_out_flag <= '1';
            else
                --not requesting data so set new data out to low
                kernel_out_flag <= '0';
            end if;
        end if;
    end process;

end rtl;
