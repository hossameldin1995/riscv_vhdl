--!
--! Copyright 2019 Sergey Khabarov, sergeykhbr@gmail.com
--!
--! Licensed under the Apache License, Version 2.0 (the "License");
--! you may not use this file except in compliance with the License.
--! You may obtain a copy of the License at
--!
--!     http://www.apache.org/licenses/LICENSE-2.0
--!
--! Unless required by applicable law or agreed to in writing, software
--! distributed under the License is distributed on an "AS IS" BASIS,
--! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--! See the License for the specific language governing permissions and
--! limitations under the License.
--!

--! Standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--! Data transformation and math functions library
library commonlib;
use commonlib.types_common.all;

--! Technology definition library.
library techmap;
--! Technology constants definition.
use techmap.gencomp.all;
--! "Virtual" PLL declaration.
use techmap.types_pll.all;
--! "Virtual" buffers declaration.
use techmap.types_buf.all;

 --! Top-level implementaion library
library work;
--! Target dependable configuration: RTL, FPGA or ASIC.
use work.config_target.all;

entity top_c5g is
port
(

	------------ CLOCK ------------
	CLOCK2_50       	:in    	std_logic;
	CLOCK3_50       	:in    	std_logic;
	CLOCK4_50       	:in    	std_logic;
	CLOCK_50        	:in    	std_logic;
	
	------------ reset ------------
	i_rst             :in      std_logic; -- PIN_AA15

	------------ KEY ------------
	KEY             	:in    	std_logic_vector(2 downto 0);

	------------ SW ------------
	SW              	:in    	std_logic_vector(9 downto 0);

	------------ LED ------------
	LEDR            	:out   	std_logic_vector(9 downto 0);

	------------ Seg7 ------------
	HEX0            	:out   	std_logic_vector(6 downto 0);
	HEX1            	:out   	std_logic_vector(6 downto 0);
	HEX2            	:out   	std_logic_vector(6 downto 0);
	HEX3            	:out   	std_logic_vector(6 downto 0);
	HEX4            	:out   	std_logic_vector(6 downto 0);
	HEX5            	:out   	std_logic_vector(6 downto 0);

	------------ SDRAM ------------
	DRAM_ADDR       	:out   	std_logic_vector(12 downto 0);
	DRAM_BA         	:out   	std_logic_vector(1 downto 0);
	DRAM_CAS_N      	:out   	std_logic;
	DRAM_CKE        	:out   	std_logic;
	DRAM_CLK        	:out   	std_logic;
	DRAM_CS_N       	:out   	std_logic;
	DRAM_DQ         	:inout 	std_logic_vector(15 downto 0);
	DRAM_LDQM       	:out   	std_logic;
	DRAM_RAS_N      	:out   	std_logic;
	DRAM_UDQM       	:out   	std_logic;
	DRAM_WE_N       	:out   	std_logic;

	------------ Audio ------------
	AUD_ADCDAT      	:in    	std_logic;
	AUD_ADCLRCK     	:inout 	std_logic;
	AUD_BCLK        	:inout 	std_logic;
	AUD_DACDAT      	:out   	std_logic;
	AUD_DACLRCK     	:inout 	std_logic;
	AUD_XCK         	:out   	std_logic;

	------------ ADC ------------
	ADC_CONVST      	:out   	std_logic;
	ADC_DIN         	:out   	std_logic;
	ADC_DOUT        	:in    	std_logic;
	ADC_SCLK        	:out   	std_logic;

	------------ I2C for Audio and Video-In ------------
	FPGA_I2C_SCLK   	:out   	std_logic;
	FPGA_I2C_SDAT   	:inout 	std_logic;

	------------ IR ------------
	IRDA_RXD        	:in    	std_logic;
	IRDA_TXD        	:out   	std_logic;

	------------ GPIO, GPIO connect to GPIO Default ------------
	GPIO            	:inout 	std_logic_vector(35 downto 0);
	
	--! Differential clock (LVDS) positive/negaive signal.
  i_sclk_p  : in std_logic;
  i_sclk_n  : in std_logic;
  --! GPIO: [11:4] LEDs; [3:0] DIP switch
  io_gpio     : inout std_logic_vector(11 downto 0);
  --! JTAG signals:
  i_jtag_tck : in std_logic;
  i_jtag_ntrst : in std_logic;
  i_jtag_tms : in std_logic;
  i_jtag_tdi : in std_logic;
  o_jtag_tdo : out std_logic;
  o_jtag_vref : out std_logic;
  --! UART1 signals:
  i_uart1_rd   : in std_logic;
  o_uart1_td   : out std_logic;
  --! UART2 TAP (debug port) signals: DO NOT SUPPORT FIRMWARE OUTPUT!
  i_uart2_rd   : in std_logic;
  o_uart2_td   : out std_logic;
  --! Ethernet MAC PHY interface signals
  i_gmiiclk_p : in    std_ulogic;
  i_gmiiclk_n : in    std_ulogic;
  o_egtx_clk  : out   std_ulogic;
  i_etx_clk   : in    std_ulogic;
  i_erx_clk   : in    std_ulogic;
  i_erxd      : in    std_logic_vector(3 downto 0);
  i_erx_dv    : in    std_ulogic;
  i_erx_er    : in    std_ulogic;
  i_erx_col   : in    std_ulogic;
  i_erx_crs   : in    std_ulogic;
  i_emdint    : in std_ulogic;
  o_etxd      : out   std_logic_vector(3 downto 0);
  o_etx_en    : out   std_ulogic;
  o_etx_er    : out   std_ulogic;
  o_emdc      : out   std_ulogic;
  io_emdio    : inout std_logic;
  o_erstn     : out   std_ulogic
);

end entity;



---------------------------------------------------------
--  Structural coding
---------------------------------------------------------


architecture arch_top_c5g of top_c5g is

component riscv_soc is port 
( 
  i_rst     : in std_logic;
  i_clk  : in std_logic;
  --! GPIO.
  i_gpio     : in std_logic_vector(11 downto 0);
  o_gpio     : out std_logic_vector(11 downto 0);
  o_gpio_dir : out std_logic_vector(11 downto 0);
  --! GPTimers
  o_pwm : out std_logic_vector(1 downto 0);
  --! JTAG signals:
  i_jtag_tck : in std_logic;
  i_jtag_ntrst : in std_logic;
  i_jtag_tms : in std_logic;
  i_jtag_tdi : in std_logic;
  o_jtag_tdo : out std_logic;
  o_jtag_vref : out std_logic;
  --! UART1 signals:
  i_uart1_ctsn : in std_logic;
  i_uart1_rd   : in std_logic;
  o_uart1_td   : out std_logic;
  o_uart1_rtsn : out std_logic;
  --! UART2 (debug port) signals:
  i_uart2_ctsn : in std_logic;
  i_uart2_rd   : in std_logic;
  o_uart2_td   : out std_logic;
  o_uart2_rtsn : out std_logic;
  --! SPI Flash
  i_flash_si : in std_logic;
  o_flash_so : out std_logic;
  o_flash_sck : out std_logic;
  o_flash_csn : out std_logic;
  o_flash_wpn : out std_logic;
  o_flash_holdn : out std_logic;
  o_flash_reset : out std_logic;
  --! OTP Memory
  i_otp_d : in std_logic_vector(15 downto 0);
  o_otp_d : out std_logic_vector(15 downto 0);
  o_otp_a : out std_logic_vector(11 downto 0);
  o_otp_we : out std_logic;
  o_otp_re : out std_logic;
  --! Ethernet MAC PHY interface signals
  i_etx_clk   : in    std_ulogic;
  i_erx_clk   : in    std_ulogic;
  i_erxd      : in    std_logic_vector(3 downto 0);
  i_erx_dv    : in    std_ulogic;
  i_erx_er    : in    std_ulogic;
  i_erx_col   : in    std_ulogic;
  i_erx_crs   : in    std_ulogic;
  i_emdint    : in std_ulogic;
  o_etxd      : out   std_logic_vector(3 downto 0);
  o_etx_en    : out   std_ulogic;
  o_etx_er    : out   std_ulogic;
  o_emdc      : out   std_ulogic;
  i_eth_mdio    : in std_logic;
  o_eth_mdio    : out std_logic;
  o_eth_mdio_oe : out std_logic;
  i_eth_gtx_clk    : in std_logic;
  i_eth_gtx_clk_90 : in std_logic;
  o_erstn     : out   std_ulogic;
  -- GNSS Sub-system signals:
  i_clk_adc : in std_logic;
  i_gps_I : in std_logic_vector(1 downto 0);
  i_gps_Q : in std_logic_vector(1 downto 0);
  i_glo_I : in std_logic_vector(1 downto 0);
  i_glo_Q : in std_logic_vector(1 downto 0);
  o_pps : out std_logic;
  i_gps_ld    : in std_logic;
  i_glo_ld    : in std_logic;
  o_max_sclk  : out std_logic;
  o_max_sdata : out std_logic;
  o_max_ncs   : out std_logic_vector(1 downto 0);
  i_antext_stat   : in std_logic;
  i_antext_detect : in std_logic;
  o_antext_ena    : out std_logic;
  o_antint_contr  : out std_logic
);
end component;

  signal ib_rst     : std_logic;
  signal ib_clk_tcxo : std_logic;
  signal ib_sclk_n  : std_logic;

  signal ob_gpio_direction : std_logic_vector(11 downto 0);
  signal ob_gpio_opins    : std_logic_vector(11 downto 0);
  signal ib_gpio_ipins     : std_logic_vector(11 downto 0);
  signal ib_uart1_rd    : std_logic;
  signal ob_uart1_td    : std_logic;
  signal ib_uart2_rd    : std_logic;
  signal ob_uart2_td    : std_logic;
  --! JTAG signals:
  signal ib_jtag_tck    : std_logic;
  signal ib_jtag_ntrst  : std_logic;
  signal ib_jtag_tms    : std_logic;
  signal ib_jtag_tdi    : std_logic;
  signal ob_jtag_tdo    : std_logic;
  signal ob_jtag_vref   : std_logic;

  signal ib_gmiiclk : std_logic;
  signal ib_eth_mdio : std_logic;
  signal ob_eth_mdio : std_logic;
  signal ob_eth_mdio_oe : std_logic;
  signal w_eth_gtx_clk : std_logic;
  signal w_eth_gtx_clk_90 : std_logic;

  signal w_ext_reset : std_ulogic; -- External system reset or PLL unlcoked. MUST NOT USED BY DEVICES.
  signal w_glob_rst  : std_ulogic; -- Global reset active HIGH
  signal w_glob_nrst : std_ulogic; -- Global reset active LOW
  signal w_soft_rst : std_ulogic; -- Software reset (acitve HIGH) from DSU
  signal w_bus_nrst : std_ulogic; -- Global reset and Soft Reset active LOW
  signal w_clk_bus  : std_ulogic; -- bus clock from the internal PLL (100MHz virtex6/40MHz Spartan6)
  signal w_pll_lock : std_ulogic; -- PLL status signal. 0=Unlocked; 1=locked.

begin

  --! PAD buffers:
  irst0   : ibuf_tech generic map(CFG_PADTECH) port map (ib_rst, i_rst);

  iclk0 : idsbuf_tech generic map (CFG_PADTECH) port map (
         i_sclk_p, i_sclk_n, ib_clk_tcxo);

  ird1 : ibuf_tech generic map(CFG_PADTECH) port map (ib_uart1_rd, i_uart1_rd);
  otd1 : obuf_tech generic map(CFG_PADTECH) port map (o_uart1_td, ob_uart1_td);

  ird2 : ibuf_tech generic map(CFG_PADTECH) port map (ib_uart2_rd, i_uart2_rd);
  otd2 : obuf_tech generic map(CFG_PADTECH) port map (o_uart2_td, ob_uart2_td);

  gpiox : for i in 0 to 11 generate
    iob0  : iobuf_tech generic map(CFG_PADTECH) 
            port map (ib_gpio_ipins(i), io_gpio(i), ob_gpio_opins(i), ob_gpio_direction(i));
  end generate;

  --! JTAG signals:
  ijtck0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tck, i_jtag_tck);
  ijtrst0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_ntrst, i_jtag_ntrst);
  ijtms0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tms, i_jtag_tms);
  ijtdi0 : ibuf_tech generic map(CFG_PADTECH) port map (ib_jtag_tdi, i_jtag_tdi);
  ojtdo0 : obuf_tech generic map(CFG_PADTECH) port map (o_jtag_tdo, ob_jtag_tdo);
  ojvrf0 : obuf_tech generic map(CFG_PADTECH) port map (o_jtag_vref, ob_jtag_vref);

  igbebuf0 : igdsbuf_tech generic map (CFG_PADTECH) port map (
            i_gmiiclk_p, i_gmiiclk_n, ib_gmiiclk);
				
  iomdio : iobuf_tech generic map(CFG_PADTECH)
	        port map (ib_eth_mdio, io_emdio, ob_eth_mdio, ob_eth_mdio_oe);

  --! Gigabit clock phase rotator with buffers
  clkrot90 : clkp90_tech  generic map (
      tech    => CFG_FABTECH,
      freq    => 125000   -- KHz = 125 MHz
    ) port map (
      i_rst    => ib_rst,
      i_clk    => ib_gmiiclk,
      o_clk    => w_eth_gtx_clk,
      o_clkp90 => w_eth_gtx_clk_90,
      o_clk2x  => open, -- used in gbe 'io_ref'
      o_lock   => open
    );

  o_egtx_clk <= w_eth_gtx_clk;

  ------------------------------------
  -- @brief Internal PLL device instance.
  pll0 : SysPLL_tech generic map (
    tech => CFG_FABTECH
  ) port map (
    i_reset     => ib_rst,
    i_clk_tcxo	=> ib_clk_tcxo,
    o_clk_bus   => w_clk_bus,
    o_locked    => w_pll_lock
  );
  w_ext_reset <= ib_rst or not w_pll_lock;


  soc0 : riscv_soc port map
  ( 
    i_rst  => w_ext_reset,
    i_clk  => w_clk_bus,
    --! GPIO.
    i_gpio     => ib_gpio_ipins,
    o_gpio     => ob_gpio_opins,
    o_gpio_dir => ob_gpio_direction,
    o_pwm => open,
    --! JTAG signals:
    i_jtag_tck => ib_jtag_tck,
    i_jtag_ntrst => ib_jtag_ntrst,
    i_jtag_tms => ib_jtag_tms,
    i_jtag_tdi => ib_jtag_tdi,
    o_jtag_tdo => ob_jtag_tdo,
    o_jtag_vref => ob_jtag_vref,
    --! UART1 signals:
    i_uart1_ctsn => '0',
    i_uart1_rd   => ib_uart1_rd,
    o_uart1_td   => ob_uart1_td,
    o_uart1_rtsn => open,
    --! UART2 (debug port) signals:
    i_uart2_ctsn => '0',
    i_uart2_rd   => ib_uart2_rd,
    o_uart2_td   => ob_uart2_td,
    o_uart2_rtsn => open,
    --! SPI Flash
    i_flash_si => '0',
    o_flash_so => open,
    o_flash_sck => open,
    o_flash_csn => open,
    o_flash_wpn => open,
    o_flash_holdn => open,
    o_flash_reset => open,
    --! OTP Memory
    i_otp_d => X"0000",
    o_otp_d => open,
    o_otp_a => open,
    o_otp_we => open,
    o_otp_re => open,
    --! Ethernet MAC PHY interface signals
    i_etx_clk   => i_etx_clk,
    i_erx_clk   => i_erx_clk,
    i_erxd      => i_erxd,
    i_erx_dv    => i_erx_dv,
    i_erx_er    => i_erx_er,
    i_erx_col   => i_erx_col,
    i_erx_crs   => i_erx_crs,
    i_emdint    => i_emdint,
    o_etxd      => o_etxd,
    o_etx_en    => o_etx_en,
    o_etx_er    => o_etx_er,
    o_emdc      => o_emdc,
    i_eth_mdio => ib_eth_mdio,
    o_eth_mdio => ob_eth_mdio,
    o_eth_mdio_oe => ob_eth_mdio_oe,
    i_eth_gtx_clk => w_eth_gtx_clk,
    i_eth_gtx_clk_90 => w_eth_gtx_clk_90,
    o_erstn     => o_erstn,
    -- GNSS Sub-system signals:
    i_clk_adc => '0',
    i_gps_I => "00",
    i_gps_Q => "00",
    i_glo_I => "00",
    i_glo_Q => "00",
    o_pps => open,
    i_gps_ld => '0',
    i_glo_ld => '0',
    o_max_sclk => open,
    o_max_sdata => open,
    o_max_ncs => open,
    i_antext_stat => '0',
    i_antext_detect => '0',
    o_antext_ena => open,
    o_antint_contr => open
  );

end arch_top_de10;

