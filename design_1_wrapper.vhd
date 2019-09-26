--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Wed Sep 25 20:36:07 2019
--Host        : LAPTOP-7KM49US9 running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    JA1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JA10 : out STD_LOGIC;
    JA2 : out STD_LOGIC;
    JA7 : out STD_LOGIC;
    JA8 : out STD_LOGIC;
    JA9 : out STD_LOGIC;
    JB1 : out STD_LOGIC;
    JB2 : out STD_LOGIC;
    JB3 : out STD_LOGIC;
    JC0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC5 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC6 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC7 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD5 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD6 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD7 : out STD_LOGIC_VECTOR ( 0 to 0 );
    RX : in STD_LOGIC;
    TX : out STD_LOGIC;
    cts : in STD_LOGIC;
    reset : in STD_LOGIC;
    rts : out STD_LOGIC;
    sys_clock : in STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    JB2 : out STD_LOGIC;
    JB1 : out STD_LOGIC;
    JA2 : out STD_LOGIC;
    cts : in STD_LOGIC;
    JA9 : out STD_LOGIC;
    RX : in STD_LOGIC;
    JA7 : out STD_LOGIC;
    JA8 : out STD_LOGIC;
    TX : out STD_LOGIC;
    JA10 : out STD_LOGIC;
    rts : out STD_LOGIC;
    JA1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    reset : in STD_LOGIC;
    sys_clock : in STD_LOGIC;
    JC0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC5 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC6 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JC7 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD5 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD6 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JD7 : out STD_LOGIC_VECTOR ( 0 to 0 );
    JB3 : out STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      JA1(0) => JA1(0),
      JA10 => JA10,
      JA2 => JA2,
      JA7 => JA7,
      JA8 => JA8,
      JA9 => JA9,
      JB1 => JB1,
      JB2 => JB2,
      JB3 => JB3,
      JC0(0) => JC0(0),
      JC1(0) => JC1(0),
      JC2(0) => JC2(0),
      JC3(0) => JC3(0),
      JC4(0) => JC4(0),
      JC5(0) => JC5(0),
      JC6(0) => JC6(0),
      JC7(0) => JC7(0),
      JD0(0) => JD0(0),
      JD1(0) => JD1(0),
      JD2(0) => JD2(0),
      JD3(0) => JD3(0),
      JD4(0) => JD4(0),
      JD5(0) => JD5(0),
      JD6(0) => JD6(0),
      JD7(0) => JD7(0),
      RX => RX,
      TX => TX,
      cts => cts,
      reset => reset,
      rts => rts,
      sys_clock => sys_clock
    );
end STRUCTURE;
