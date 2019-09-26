--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Wed Sep 25 20:36:07 2019
--Host        : LAPTOP-7KM49US9 running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
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
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=20,numReposBlks=20,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,da_board_cnt=18,da_clkrst_cnt=15,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_clk_wiz_1 is
  port (
    resetn : in STD_LOGIC;
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC
  );
  end component design_1_clk_wiz_1;
  component design_1_rst_clk_wiz_100M_1 is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_rst_clk_wiz_100M_1;
  component design_1_xlslice_0_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_0;
  component design_1_xlslice_0_1 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_1;
  component design_1_xlslice_0_2 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_2;
  component design_1_xlslice_0_3 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_3;
  component design_1_xlslice_0_4 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_4;
  component design_1_xlslice_0_5 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_5;
  component design_1_xlslice_0_6 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_6;
  component design_1_xlslice_0_7 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_7;
  component design_1_xlslice_0_8 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_8;
  component design_1_xlslice_0_9 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_9;
  component design_1_xlslice_0_10 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_10;
  component design_1_xlslice_0_11 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_11;
  component design_1_xlslice_0_12 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_12;
  component design_1_xlslice_0_13 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_13;
  component design_1_xlslice_0_14 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_14;
  component design_1_xlslice_0_15 is
  port (
    Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1_xlslice_0_15;
  component design_1_phy_uart_tester_0_0 is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    read : out STD_LOGIC;
    read_data : in STD_LOGIC_VECTOR ( 7 downto 0 );
    read_ready : in STD_LOGIC;
    write : out STD_LOGIC;
    write_data : out STD_LOGIC_VECTOR ( 7 downto 0 );
    write_full : in STD_LOGIC
  );
  end component design_1_phy_uart_tester_0_0;
  component design_1_uart_0_3 is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    rx_fifo_renable : in STD_LOGIC;
    uart_data_out : out STD_LOGIC_VECTOR ( 7 downto 0 );
    uart_rx_not_empty : out STD_LOGIC;
    tx_fifo_wenable : in STD_LOGIC;
    uart_data_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    uart_tx_full : out STD_LOGIC;
    RX : in STD_LOGIC;
    rts : out STD_LOGIC;
    TX : out STD_LOGIC;
    cts : in STD_LOGIC;
    temp : out STD_LOGIC
  );
  end component design_1_uart_0_3;
  signal CLK100MHZ_1 : STD_LOGIC;
  signal CPU_RESETN_1 : STD_LOGIC;
  signal RX_1 : STD_LOGIC;
  signal clk_wiz_1_clk_out1 : STD_LOGIC;
  signal cts_1 : STD_LOGIC;
  signal phy_uart_tester_0_read : STD_LOGIC;
  signal phy_uart_tester_0_write : STD_LOGIC;
  signal phy_uart_tester_0_write_data : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal rst_clk_wiz_100M_peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal uart_0_TX : STD_LOGIC;
  signal uart_0_rts : STD_LOGIC;
  signal uart_0_temp : STD_LOGIC;
  signal uart_0_uart_data_out : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal uart_0_uart_rx_empty : STD_LOGIC;
  signal uart_0_uart_tx_full : STD_LOGIC;
  signal xlslice_0_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_10_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_11_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_12_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_13_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_14_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_15_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_1_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_2_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_3_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_4_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_5_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_6_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_7_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_8_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_9_Dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_clk_wiz_100M_mb_reset_UNCONNECTED : STD_LOGIC;
  signal NLW_rst_clk_wiz_100M_bus_struct_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_clk_wiz_100M_interconnect_aresetn_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_clk_wiz_100M_peripheral_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of reset : signal is "xilinx.com:signal:reset:1.0 RST.RESET RST";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of reset : signal is "XIL_INTERFACENAME RST.RESET, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of sys_clock : signal is "xilinx.com:signal:clock:1.0 CLK.SYS_CLOCK CLK";
  attribute X_INTERFACE_PARAMETER of sys_clock : signal is "XIL_INTERFACENAME CLK.SYS_CLOCK, CLK_DOMAIN design_1_sys_clock, FREQ_HZ 100000000, PHASE 0.000";
begin
  CLK100MHZ_1 <= sys_clock;
  CPU_RESETN_1 <= reset;
  JA1(0) <= rst_clk_wiz_100M_peripheral_aresetn(0);
  JA10 <= uart_0_rts;
  JA2 <= clk_wiz_1_clk_out1;
  JA7 <= RX_1;
  JA8 <= uart_0_TX;
  JA9 <= cts_1;
  JB1 <= phy_uart_tester_0_read;
  JB2 <= phy_uart_tester_0_write;
  JB3 <= uart_0_temp;
  JC0(0) <= xlslice_0_Dout(0);
  JC1(0) <= xlslice_1_Dout(0);
  JC2(0) <= xlslice_2_Dout(0);
  JC3(0) <= xlslice_3_Dout(0);
  JC4(0) <= xlslice_4_Dout(0);
  JC5(0) <= xlslice_5_Dout(0);
  JC6(0) <= xlslice_6_Dout(0);
  JC7(0) <= xlslice_7_Dout(0);
  JD0(0) <= xlslice_8_Dout(0);
  JD1(0) <= xlslice_9_Dout(0);
  JD2(0) <= xlslice_10_Dout(0);
  JD3(0) <= xlslice_11_Dout(0);
  JD4(0) <= xlslice_12_Dout(0);
  JD5(0) <= xlslice_13_Dout(0);
  JD6(0) <= xlslice_14_Dout(0);
  JD7(0) <= xlslice_15_Dout(0);
  RX_1 <= RX;
  TX <= uart_0_TX;
  cts_1 <= cts;
  rts <= uart_0_rts;
clk_wiz: component design_1_clk_wiz_1
     port map (
      clk_in1 => CLK100MHZ_1,
      clk_out1 => clk_wiz_1_clk_out1,
      resetn => CPU_RESETN_1
    );
phy_uart_tester_0: component design_1_phy_uart_tester_0_0
     port map (
      clk => clk_wiz_1_clk_out1,
      read => phy_uart_tester_0_read,
      read_data(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      read_ready => uart_0_uart_rx_empty,
      rst => rst_clk_wiz_100M_peripheral_aresetn(0),
      write => phy_uart_tester_0_write,
      write_data(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      write_full => uart_0_uart_tx_full
    );
rst_clk_wiz_100M: component design_1_rst_clk_wiz_100M_1
     port map (
      aux_reset_in => '1',
      bus_struct_reset(0) => NLW_rst_clk_wiz_100M_bus_struct_reset_UNCONNECTED(0),
      dcm_locked => '1',
      ext_reset_in => CPU_RESETN_1,
      interconnect_aresetn(0) => NLW_rst_clk_wiz_100M_interconnect_aresetn_UNCONNECTED(0),
      mb_debug_sys_rst => '0',
      mb_reset => NLW_rst_clk_wiz_100M_mb_reset_UNCONNECTED,
      peripheral_aresetn(0) => rst_clk_wiz_100M_peripheral_aresetn(0),
      peripheral_reset(0) => NLW_rst_clk_wiz_100M_peripheral_reset_UNCONNECTED(0),
      slowest_sync_clk => clk_wiz_1_clk_out1
    );
uart_0: component design_1_uart_0_3
     port map (
      RX => RX_1,
      TX => uart_0_TX,
      clk => clk_wiz_1_clk_out1,
      cts => cts_1,
      rst => rst_clk_wiz_100M_peripheral_aresetn(0),
      rts => uart_0_rts,
      rx_fifo_renable => phy_uart_tester_0_read,
      temp => uart_0_temp,
      tx_fifo_wenable => phy_uart_tester_0_write,
      uart_data_in(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      uart_data_out(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      uart_rx_not_empty => uart_0_uart_rx_empty,
      uart_tx_full => uart_0_uart_tx_full
    );
xlslice_0: component design_1_xlslice_0_0
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_0_Dout(0)
    );
xlslice_1: component design_1_xlslice_0_1
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_1_Dout(0)
    );
xlslice_10: component design_1_xlslice_0_10
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_10_Dout(0)
    );
xlslice_11: component design_1_xlslice_0_11
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_11_Dout(0)
    );
xlslice_12: component design_1_xlslice_0_12
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_12_Dout(0)
    );
xlslice_13: component design_1_xlslice_0_13
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_13_Dout(0)
    );
xlslice_14: component design_1_xlslice_0_14
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_14_Dout(0)
    );
xlslice_15: component design_1_xlslice_0_15
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_15_Dout(0)
    );
xlslice_2: component design_1_xlslice_0_2
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_2_Dout(0)
    );
xlslice_3: component design_1_xlslice_0_3
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_3_Dout(0)
    );
xlslice_4: component design_1_xlslice_0_4
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_4_Dout(0)
    );
xlslice_5: component design_1_xlslice_0_5
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_5_Dout(0)
    );
xlslice_6: component design_1_xlslice_0_6
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_6_Dout(0)
    );
xlslice_7: component design_1_xlslice_0_7
     port map (
      Din(7 downto 0) => uart_0_uart_data_out(7 downto 0),
      Dout(0) => xlslice_7_Dout(0)
    );
xlslice_8: component design_1_xlslice_0_8
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_8_Dout(0)
    );
xlslice_9: component design_1_xlslice_0_9
     port map (
      Din(7 downto 0) => phy_uart_tester_0_write_data(7 downto 0),
      Dout(0) => xlslice_9_Dout(0)
    );
end STRUCTURE;
