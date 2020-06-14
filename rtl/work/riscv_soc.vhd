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

--! AMBA system bus specific library
library ambalib;
--! AXI4 configuration constants.
use ambalib.types_amba4.all;
use ambalib.types_bus0.all;
--! Misc modules library
library misclib;
use misclib.types_misc.all;

--! River CPU specific library
library riverlib;
--! River top level with AMBA interface module declaration
use riverlib.types_river.all;

 --! Top-level implementaion library
library work;
--! Target dependable configuration: RTL, FPGA or ASIC.
use work.config_target.all;

--! @brief   SOC Top-level entity declaration.
--! @details This module implements full SOC functionality and all IO signals
--!          are available on FPGA/ASIC IO pins.
entity riscv_soc is port 
( 
  i_rst : in std_logic;
  i_clk  : in std_logic;
  --! GPIO.
  i_gpio     : in std_logic_vector(11 downto 0);
  o_gpio     : out std_logic_vector(11 downto 0);
  o_gpio_dir : out std_logic_vector(11 downto 0);
  --! GPTimers
  o_pwm : out std_logic_vector(1 downto 0);
  --! UART1 signals:
  i_uart1_ctsn : in std_logic;
  i_uart1_rd   : in std_logic;
  o_uart1_td   : out std_logic;
  o_uart1_rtsn : out std_logic
);
  --! @}

end riscv_soc;

--! @brief SOC top-level  architecture declaration.
architecture arch_riscv_soc of riscv_soc is

  signal w_glob_rst  : std_ulogic; -- Global reset active HIGH
  signal w_glob_nrst : std_ulogic; -- Global reset active LOW
  signal w_soft_rst : std_ulogic:='0'; -- Software reset (acitve HIGH) from DSU
  signal w_bus_nrst : std_ulogic; -- Global reset and Soft Reset active LOW
  
  signal uart1i : uart_in_type;
  signal uart1o : uart_out_type;

  signal corei   : axi4_river_in_vector;
  signal coreo   : axi4_river_out_vector;

  --! Arbiter is switching only slaves output signal, data from noc
  --! is connected to all slaves and to the arbiter itself.
  signal aximi   : bus0_xmst_in_vector;
  signal aximo   : bus0_xmst_out_vector;
  signal axisi   : bus0_xslv_in_vector;
  signal axiso   : bus0_xslv_out_vector;
  signal slv_cfg : bus0_xslv_cfg_vector;
  signal mst_cfg : bus0_xmst_cfg_vector;
  signal wb_core_irq : std_logic_vector(CFG_TOTAL_CPU_MAX-1 downto 0);
  signal w_ext_irq : std_logic;
  signal dport_i : dport_in_vector;
  signal dport_o : dport_out_vector;
  signal wb_bus_util_w : std_logic_vector(CFG_BUS0_XMST_TOTAL-1 downto 0);
  signal wb_bus_util_r : std_logic_vector(CFG_BUS0_XMST_TOTAL-1 downto 0);

  signal irq_pins : std_logic_vector(CFG_IRQ_TOTAL-1 downto 1);
begin


 ------------------------------------
  --! @brief System Reset device instance.
  rst0 : reset_global port map (
    inSysReset  => i_rst,
    inSysClk    => i_clk,
    outReset    => w_glob_rst
  );
  w_glob_nrst <= not w_glob_rst;
  w_bus_nrst <= not (w_glob_rst or w_soft_rst);

  --! @brief AXI4 controller.
  ctrl0 : axictrl_bus0 generic map (
    async_reset => CFG_ASYNC_RESET
  ) port map (
    i_clk    => i_clk,
    i_nrst   => w_glob_nrst,
    i_slvcfg => slv_cfg,
    i_slvo   => axiso,
    i_msto   => aximo,
    o_slvi   => axisi,
    o_msti   => aximi,
    o_bus_util_w => wb_bus_util_w, -- Bus write access utilization per master statistic
    o_bus_util_r => wb_bus_util_r  -- Bus read access utilization per master statistic
  );

  wb_core_irq <= "0" & w_ext_irq;  -- TODO: other CPU interrupts

  --! @brief RISC-V Processor core River.
  cpuslotx : for n in 0 to CFG_TOTAL_CPU_MAX-1 generate
      cpux : if n < CFG_CPU_NUM generate
          river0 : river_amba generic map (
            memtech  => CFG_MEMTECH,
            hartid => n,
            async_reset => CFG_ASYNC_RESET,
            fpu_ena => CFG_FPU_ENABLE,
            coherence_ena => false,
            tracer_ena => false
          ) port map ( 
            i_nrst   => w_bus_nrst,
            i_clk    => i_clk,
            i_msti   => corei(CFG_BUS0_XMST_CPU0+n),
            o_msto   => coreo(CFG_BUS0_XMST_CPU0+n),
            o_mstcfg => mst_cfg(CFG_BUS0_XMST_CPU0+n),
            i_dport => dport_i(n),
            o_dport => dport_o(n),
            i_ext_irq => wb_core_irq(n)
          );
      end generate;
      emptyx : if n >= CFG_CPU_NUM generate
          coreo(CFG_BUS0_XMST_CPU0+n) <= axi4_river_out_none;
          mst_cfg(CFG_BUS0_XMST_CPU0+n) <= axi4_master_config_none;
          dport_o(n) <= dport_out_none;
      end generate;
  end generate;

  l2_ena : if CFG_L2CACHE_ENA generate
      -- TODO:
  end generate;
  l2_dis : if not CFG_L2CACHE_ENA generate
      serdesslotx : for n in 0 to CFG_TOTAL_CPU_MAX-1 generate
          serdesx : if n < CFG_CPU_NUM generate
              serdes0 : river_serdes generic map (
                async_reset => CFG_ASYNC_RESET
              ) port map ( 
                i_nrst  => w_bus_nrst,
                i_clk   => i_clk,
                i_coreo => coreo(CFG_BUS0_XMST_CPU0+n),
                o_corei => corei(CFG_BUS0_XMST_CPU0+n),
                i_msti => aximi(CFG_BUS0_XMST_CPU0+n),
                o_msto => aximo(CFG_BUS0_XMST_CPU0+n)
              );
          end generate;
          serdesemptyx : if n >= CFG_CPU_NUM generate
              aximo(CFG_BUS0_XMST_CPU0+n) <= axi4_master_out_none;
          end generate;
      end generate;
  end generate;



  ------------------------------------
  --! @brief BOOT ROM module instance with the AXI4 interface.
  --! @details Map address:
  --!          0x00000000..0x00000000+((CFG_ROM_SIZE*1024) - 1)
  boot0 : axi4_rom generic map (
    memtech  => CFG_MEMTECH,
    async_reset => CFG_ASYNC_RESET,
    xaddr    => 16#00000#,
    xmask    => CFG_ROM_MASK,
    sim_hexfile => CFG_SIM_BOOTROM_HEX
  ) port map (
    clk  => i_clk,
    nrst => w_glob_nrst,
    cfg  => slv_cfg(CFG_BUS0_XSLV_BOOTROM),
    i    => axisi(CFG_BUS0_XSLV_BOOTROM),
    o    => axiso(CFG_BUS0_XSLV_BOOTROM)
  );

  ------------------------------------
  --! @brief Firmware Image ROM with the AXI4 interface.
  --! @details Map address:
  --!          0x00100000..0x0013ffff (256 KB total)
  --! @warning Don't forget to change ROM_ADDR_WIDTH in rom implementation
  img0 : axi4_rom generic map (
    memtech  => CFG_MEMTECH,
    async_reset => CFG_ASYNC_RESET,
    xaddr    => 16#00100#,
    xmask    => CFG_ROM_APP_MASK,
    sim_hexfile => CFG_SIM_FWIMAGE_HEX
  ) port map (
    clk  => i_clk,
    nrst => w_glob_nrst,
    cfg  => slv_cfg(CFG_BUS0_XSLV_ROMIMAGE),
    i    => axisi(CFG_BUS0_XSLV_ROMIMAGE),
    o    => axiso(CFG_BUS0_XSLV_ROMIMAGE)
  );

  ------------------------------------
  --! Internal SRAM module instance with the AXI4 interface.
  --! @details Map address:
  --!          0x10000000..0x10000000+((CFG_RAM_SIZE*1024) - 1)
  sram0 : axi4_sram generic map (
    memtech  => CFG_MEMTECH,
    async_reset => CFG_ASYNC_RESET,
    xaddr    => 16#10000#,
    xmask    => CFG_RAM_MASK,
    abits    => (10 + log2(CFG_RAM_SIZE)),
    init_file => CFG_SIM_FWIMAGE_HEX  -- Used only for inferred
  ) port map (
    clk  => i_clk,
    nrst => w_glob_nrst,
    cfg  => slv_cfg(CFG_BUS0_XSLV_SRAM),
    i    => axisi(CFG_BUS0_XSLV_SRAM),
    o    => axiso(CFG_BUS0_XSLV_SRAM)
  );


  ------------------------------------
  --! @brief Controller of the LEDs, DIPs and GPIO with the AXI4 interface.
  --! @details Map address:
  --!          0x80000000..0x80000fff (4 KB total)
  gpio0 : axi4_gpio generic map (
    async_reset => CFG_ASYNC_RESET,
    xaddr    => 16#80000#,
    xmask    => 16#fffff#,
    xirq     => 0,
    width    => 12
  ) port map (
    clk   => i_clk,
    nrst  => w_glob_nrst,
    cfg   => slv_cfg(CFG_BUS0_XSLV_GPIO),
    i     => axisi(CFG_BUS0_XSLV_GPIO),
    o     => axiso(CFG_BUS0_XSLV_GPIO),
    i_gpio => i_gpio,
    o_gpio => o_gpio,
    o_gpio_dir => o_gpio_dir
  );
  
  
  ------------------------------------
  uart1i.cts   <= not i_uart1_ctsn;
  uart1i.rd    <= i_uart1_rd;

  --! @brief UART Controller with the AXI4 interface.
  --! @details Map address:
  --!          0x80001000..0x80001fff (4 KB total)
  uart1 : axi4_uart generic map (
    async_reset => CFG_ASYNC_RESET,
    xaddr    => 16#80001#,
    xmask    => 16#FFFFF#,
    xirq     => CFG_IRQ_UART1,
    fifosz   => 16
  ) port map (
    nrst   => w_glob_nrst, 
    clk    => i_clk, 
    cfg    => slv_cfg(CFG_BUS0_XSLV_UART1),
    i_uart => uart1i, 
    o_uart => uart1o,
    i_axi  => axisi(CFG_BUS0_XSLV_UART1),
    o_axi  => axiso(CFG_BUS0_XSLV_UART1),
    o_irq  => irq_pins(CFG_IRQ_UART1)
  );
  o_uart1_td  <= uart1o.td;
  o_uart1_rtsn <= not uart1o.rts;


  ------------------------------------
  --! @brief Interrupt controller with the AXI4 interface.
  --! @details Map address:
  --!          0x80002000..0x80002fff (4 KB total)
  irq0 : axi4_irqctrl generic map (
    async_reset => CFG_ASYNC_RESET,
    xaddr      => 16#80002#,
    xmask      => 16#FFFFF#
  ) port map (
    clk    => i_clk,
    nrst   => w_bus_nrst,
    i_irqs => irq_pins,
    o_cfg  => slv_cfg(CFG_BUS0_XSLV_IRQCTRL),
    i_axi  => axisi(CFG_BUS0_XSLV_IRQCTRL),
    o_axi  => axiso(CFG_BUS0_XSLV_IRQCTRL),
    o_irq_meip => w_ext_irq
  );

  --! @brief Timers with the AXI4 interface.
  --! @details Map address:
  --!          0x80005000..0x80005fff (4 KB total)
  gptmr0 : axi4_gptimers  generic map (
    async_reset => CFG_ASYNC_RESET,
    xaddr     => 16#80005#,
    xmask     => 16#fffff#,
    xirq      => CFG_IRQ_GPTIMERS,
    tmr_total => 2
  ) port map (
    clk    => i_clk,
    nrst   => w_glob_nrst,
    cfg    => slv_cfg(CFG_BUS0_XSLV_GPTIMERS),
    i_axi  => axisi(CFG_BUS0_XSLV_GPTIMERS),
    o_axi  => axiso(CFG_BUS0_XSLV_GPTIMERS),
    o_pwm  => o_pwm,
    o_irq  => irq_pins(CFG_IRQ_GPTIMERS)
  );





end arch_riscv_soc;
