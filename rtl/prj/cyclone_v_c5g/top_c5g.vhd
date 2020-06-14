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

	--------- CLOCK ---------
		CLOCK_125_p	: in std_logic;
		CLOCK_50_B3B: in std_logic;
		CLOCK_50_B5B: in std_logic;
		CLOCK_50_B6A: in std_logic;
		CLOCK_50_B7A: in std_logic;
		CLOCK_50_B8A: in std_logic;
		
		--------- CPU ---------
		CPU_RESET_n	: in std_logic;
		
		--------- GPIO ---------
		GPIO_IN		: in std_logic_vector(17 DOWNTO 0);
		GPIO_OUT		: out std_logic_vector(17 DOWNTO 0);
		
		--------- HEX0 ---------
		HEX0			: out std_logic_vector(6 DOWNTO 0);

		--------- HEX1 ---------
		HEX1			: out std_logic_vector(6 DOWNTO 0);
		
		--------- HEX2 ---------
		HEX2			: out std_logic_vector(6 DOWNTO 0);
		
		--------- HEX3 ---------
		HEX3			: out std_logic_vector(6 DOWNTO 0);
		
		--------- KEY ---------
		KEY_n			: in std_logic_vector(3 DOWNTO 0);

		--------- LEDG ---------
		LEDG			: out std_logic_vector(7 DOWNTO 0);

		--------- LEDR ---------
		LEDR			: out std_logic_vector(9 DOWNTO 0);
		
		--------- SW ---------
		SW				: in std_logic_vector(9 DOWNTO 0);

		--------- UART ---------
		UART_RX		: in std_logic;
		UART_TX		: out std_logic;
	
  --! GPIO: [11:4] LEDs; [3:0] DIP switch
  io_gpio     : inout std_logic_vector(11 downto 0)
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
  --! UART1 signals:
  i_uart1_ctsn : in std_logic;
  i_uart1_rd   : in std_logic;
  o_uart1_td   : out std_logic;
  o_uart1_rtsn : out std_logic
);
end component;

  signal i_rst     : std_logic;

  signal ob_gpio_direction : std_logic_vector(11 downto 0);
  signal ob_gpio_opins    : std_logic_vector(11 downto 0);
  signal ib_gpio_ipins     : std_logic_vector(11 downto 0);

  signal w_ext_reset : std_ulogic; -- External system reset or PLL unlcoked. MUST NOT USED BY DEVICES.
  signal w_clk_bus  : std_ulogic; -- bus clock from the internal PLL (100MHz virtex6/40MHz Spartan6)
  signal w_pll_lock : std_ulogic; -- PLL status signal. 0=Unlocked; 1=locked.

begin

  i_rst <= not(CPU_RESET_n);
  
  --! PAD buffers:

  gpiox : for i in 0 to 11 generate
    iob0  : iobuf_tech generic map(CFG_PADTECH) 
            port map (ib_gpio_ipins(i), io_gpio(i), ob_gpio_opins(i), ob_gpio_direction(i));
  end generate;

  ------------------------------------
  -- @brief Internal PLL device instance.
  pll0 : SysPLL_tech generic map (
    tech => CFG_FABTECH
  ) port map (
    i_reset     => i_rst,
    i_clk_tcxo	=> CLOCK_125_p,
    o_clk_bus   => w_clk_bus,
    o_locked    => w_pll_lock
  );
  w_ext_reset <= i_rst or not w_pll_lock;


  soc0 : riscv_soc port map
  ( 
    i_rst  => w_ext_reset,
    i_clk  => w_clk_bus,
    --! GPIO.
    i_gpio     => ib_gpio_ipins,
    o_gpio     => ob_gpio_opins,
    o_gpio_dir => ob_gpio_direction,
    --! UART1 signals:
    i_uart1_ctsn => '0',
    i_uart1_rd   => UART_RX,
    o_uart1_td   => UART_TX,
    o_uart1_rtsn => open
  );

end arch_top_c5g;

