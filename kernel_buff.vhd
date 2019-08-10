----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2019 01:28:34 PM
-- Design Name: 
-- Module Name: kernel_buff - rtl
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

entity kernel_buff is
    PORT    (   
                clk                         : in    std_logic;
                rst                         : in    std_logic;
                
                --amount of pixel rows in kernel
                k_row                       : in    integer range 0 to 8;
                --amount of pixel columns in kernel   
                k_column                    : in    integer range 0 to 8;
                --reset signal in case of resize of line buffer or kernel
                resize_line                 : in    std_logic;
                
                --data comes from line buffer
                data_line                   : in    std_logic_vector(55 downto 0);
                --flag that data_line is ready  
                data_line_flag              : in    std_logic;  
                --kernel requesting data from line buffer
                kernel_request_line         : out   std_logic;
                
                --data that goes to line buffer
                data_out                    : out   std_logic_vector(7 downto 0);
                --flag that data_out is ready
                data_out_flag               : out   std_logic;
                --line requesting data from kernel
                line_request                : in    std_logic;
                
                --data comes from memory
                data_mem                    : in    std_logic_vector(7 downto 0);
                --flag that data_mem is ready
                data_mem_flag               : in    std_logic;
                --kernel requesting data from memory
                kernel_request_mem          : out   std_logic;
                
                --entire kernal buffer 
                k_buff                      : out   std_logic_vector(511 downto 0);
                --flag that k_buff is ready
                k_buff_flag                 : out   std_logic;
                --convolution filter requesting data
                conv_request                : in    std_logic
            );
end kernel_buff;

architecture rtl of kernel_buff is

subtype byte_type is std_logic_vector(7 downto 0);
type byte_line is array(integer range 0 to (8 * 8 - 1)) of byte_type;


--flag for when size has changed
signal size_flag            : std_logic;
--buffer of data
signal buff                 : byte_line;
--buffer of data from line buffer
signal line_buff            : std_logic_vector(55 downto 0);
--buffer of data from memory
signal mem_buff             : std_logic_vector(7 downto 0);
--temporary signal for kernel_request_line
signal request_l            : std_logic;
--temporary signal for kernel_request_mem
signal request_m            : std_logic;
--used to save new data into buff
signal update               : std_logic;


begin

    --process handles calculating the size of the kernel buffer
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
    
    --process handles receiving data from line buffer
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            kernel_request_line <= '0';
            line_buff <= (others => '0');
            request_l <= '0';
        else
            --have kernal_request_line mimic request_l and the inverse of update
            --prevents requesting data until all data was updated
            kernel_request_line <= request_l and (not update);
            
            --checks to see if a resize occured
            if(size_flag = '1') then
                line_buff <= (others => '0');
                request_l <= '0';
            else
                --checks to see if requesting data
                if(request_l = '1') then 
                    --checks to see if flag for data is set
                    if(data_line_flag = '1') then
                        --stop requesting data
                        request_l <= '0';
                        --latch in data
                        line_buff <= data_line;
                    else
                        --continue to request data
                        request_l <= '1';
                    end if;
                else
                    --checks to see if data_line_flag was reset
                    if(data_line_flag = '0') then
                        request_l <= '1';
                    else
                        --wait for flag to reset
                        request_l <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    --process handles recieving data from memory
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            kernel_request_mem <= '0';
            mem_buff <= (others => '0');
            request_m <= '0';
        else
            --have kernel_request_mem mimic request_m and the inverse of update
            --prevents requesting data until all data was updated
            kernel_request_mem <= request_m and (not update);
            
            --checks to see if a resize occured
            if(size_flag = '1') then
                mem_buff <= (others => '0');
                request_m <= '0';
            else
                --checks to see if requesting data
                if(request_m = '1') then
                    --checks to see if flag for data is set
                    if(data_mem_flag = '1') then
                        --stop requesting data
                        request_m <= '0';
                        --latch in data
                        mem_buff <= data_mem;
                    else
                        --continue to request data
                        request_m <= '1';
                    end if;
                else
                    --checks to see if data_mem_flag was reset
                    if(data_mem_flag = '0') then
                        request_m <= '1';
                    else
                        request_m <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    --process combines line_buff and mem_buff to create the kernel buffer
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            buff <= (others => (others => '0'));
            update <= '0';
        else
            --checks to see if it should update data or check for new
            if(update = '1') then
                --save new data in from memory
                buff(k_row * k_column - 1) <= mem_buff;
                --save new data from line buffer
                --makes sure mem_buff has higher priority over line_buff when saving
                if(k_row > 1) then
                    buff((k_column) - 1) <= line_buff(7 downto 0);
                end if;
                if(k_row > 2) then
                    buff((k_column * 2) - 1) <= line_buff(15 downto 8);
                end if;
                if(k_row > 3) then
                    buff((k_column * 3) - 1) <= line_buff(23 downto 16);
                end if;
                if(k_row > 4) then
                    buff((k_column * 4) - 1) <= line_buff(31 downto 24);
                end if;
                if(k_row > 5) then
                    buff((k_column * 5) - 1) <= line_buff(39 downto 32);
                end if;
                if(k_row > 6) then
                    buff((k_column * 6) - 1) <= line_buff(47 downto 40);
                end if;
                if(k_row > 7) then
                    buff((k_column * 7) - 1) <= line_buff(55 downto 48);
                end if;
                --set update to false
                update <= '0';
            else
                --waits until both data from memory and line buffer are done
                --both will stop requesting at the same time due to data_handler
                --controlling data_line_flag and data_mem_flag
                if(request_l = '0' and request_m = '0') then
                    --shift old data
                    buff((8 * 8 - 1) - 1 downto 0) <= buff((8 * 8 - 1) downto 1);
                    --set update to true
                    update <= '1';
                end if;
            end if;
        end if;
    end process;
    
    --process handles sending out the data to line_buff
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            data_out <= (others => '0');
            data_out_flag <= '0';
        else
            --checks to see if line buffer is requesting data
            if(line_request = '1') then
                --send out data of last position in the last row
                data_out <= buff(((k_row - 1) * k_column));
                --set data flag
                data_out_flag <= '1';
            else
                --reset data_out_flag
                data_out_flag <= '0';
            end if;
        end if;
    end process;
    
    --process handles sending out kernel_buff to convolution
    process
    begin
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            k_buff <= (others => '0');
            k_buff_flag <= '0';
        else
            --checks to see if convolution is requesting data
            if(conv_request = '1') then
                --send out the convolution 
                k_buff(63 downto 0) <= buff(7) & buff(6) & buff(5) & buff(4) & buff(3) & buff(2) & buff(1) & buff(0);
                k_buff(127 downto 64) <= buff(15) & buff(14) & buff(13) & buff(12) & buff(11) & buff(10) & buff(9) & buff(8);
                k_buff(191 downto 128) <= buff(23) & buff(22) & buff(21) & buff(20) & buff(19) & buff(18) & buff(17) & buff(16);
                k_buff(255 downto 192) <= buff(31) & buff(30) & buff(29) & buff(28) & buff(27) & buff(26) & buff(25) & buff(24);
                k_buff(319 downto 256) <= buff(39) & buff(38) & buff(37) & buff(36) & buff(35) & buff(34) & buff(33) & buff(32);
                k_buff(383 downto 320) <= buff(47) & buff(46) & buff(45) & buff(44) & buff(43) & buff(42) & buff(41) & buff(40);
                k_buff(447 downto 384) <= buff(55) & buff(54) & buff(53) & buff(52) & buff(51) & buff(50) & buff(49) & buff(48);
                k_buff(511 downto 448) <= buff(63) & buff(62) & buff(61) & buff(60) & buff(59) & buff(58) & buff(57) & buff(56);
                --set the flag
                k_buff_flag <= '1';
            else
                --reset the flag
                k_buff_flag <= '0';
            end if;
        end if;
    end process;

end rtl;
