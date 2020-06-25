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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;  -- or_reduce()
library commonlib;
use commonlib.types_common.all;
--! RIVER CPU specific library.
library riverlib;
--! RIVER CPU configuration constants.
use riverlib.river_cfg.all;

library target;
use target.config_target.all;

entity CsrRegs is 
  generic (
    hartid : integer;
    async_reset : boolean
  );
  port (
    i_clk : in std_logic;                                   -- CPU clock
    i_nrst : in std_logic;                                  -- Reset. Active LOW.
    i_mret : in std_logic;                                  -- mret instruction signals mode switching
    i_uret : in std_logic;                                  -- uret instruction signals mode switching
    i_sp : in std_logic_vector(RISCV_ARCH-1 downto 0);      -- Stack Pointer for the borders control
    i_addr : in std_logic_vector(11 downto 0);              -- CSR address, if xret=1 switch mode accordingly
    i_wena : in std_logic;                                  -- Write enable
    i_wdata : in std_logic_vector(RISCV_ARCH-1 downto 0);   -- CSR writing value
    o_rdata : out std_logic_vector(RISCV_ARCH-1 downto 0);  -- CSR read value
    i_trap_ready : in std_logic;                            -- Trap branch request was accepted
    i_ex_pc : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    i_ex_npc : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    i_ex_data_addr : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);-- Data path: address must be equal to the latest request address
    i_ex_data_load_fault : in std_logic;                    -- Data path: Bus response with SLVERR or DECERR on read
    i_ex_data_store_fault : in std_logic;                   -- Data path: Bus response with SLVERR or DECERR on write
    i_ex_data_store_fault_addr : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    i_ex_instr_load_fault : in std_logic;
    i_ex_illegal_instr : in std_logic;
    i_ex_unalign_store : in std_logic;
    i_ex_unalign_load : in std_logic;
    i_ex_breakpoint : in std_logic;
    i_ex_ecall : in std_logic;
    i_ex_fpu_invalidop : in std_logic;         -- FPU Exception: invalid operation
    i_ex_fpu_divbyzero : in std_logic;         -- FPU Exception: divide by zero
    i_ex_fpu_overflow : in std_logic;          -- FPU Exception: overflow
    i_ex_fpu_underflow : in std_logic;         -- FPU Exception: underflow
    i_ex_fpu_inexact : in std_logic;           -- FPU Exception: inexact
    i_fpu_valid : in std_logic;                -- FPU output is valid
    i_irq_external : in std_logic;
    o_trap_valid : out std_logic;                              -- Trap pulse
    o_trap_pc : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);-- trap on pc

    i_break_mode : in std_logic;                            -- Behaviour on EBREAK instruction: 0 = halt; 1 = generate trap
    o_break_event : out std_logic;                          -- 1 clock EBREAK detected

    i_dport_ena : in std_logic;                              -- Debug port request is enabled
    i_dport_write : in std_logic;                            -- Debug port Write enable
    i_dport_addr : in std_logic_vector(11 downto 0);         -- Debug port CSR address
    i_dport_wdata : in std_logic_vector(RISCV_ARCH-1 downto 0);-- Debug port CSR writing value
    o_dport_rdata : out std_logic_vector(RISCV_ARCH-1 downto 0)-- Debug port CSR read value
  );
end; 
 
architecture arch_CsrRegs of CsrRegs is

  type RegistersType is record
      mtvec : std_logic_vector(RISCV_ARCH-1 downto 0);
      mscratch : std_logic_vector(RISCV_ARCH-1 downto 0);
      mstackovr : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      mstackund : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      mbadaddr : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      mode : std_logic_vector(1 downto 0);
      uie : std_logic;                       -- User level interrupts ena for current priv. mode
      mie : std_logic;                       -- Machine level interrupts ena for current priv. mode
      mpie : std_logic;                      -- Previous MIE value
      mstackovr_ena : std_logic;             -- Stack Overflow control enabled
      mstackund_ena : std_logic;             -- Stack Underflow control enabled
      mpp : std_logic_vector(1 downto 0);    -- Previous mode
      mepc : std_logic_vector(RISCV_ARCH-1 downto 0);
      ext_irq : std_logic;

      ex_fpu_invalidop : std_logic;          -- FPU Exception: invalid operation
      ex_fpu_divbyzero : std_logic;          -- FPU Exception: divide by zero
      ex_fpu_overflow : std_logic;           -- FPU Exception: overflow
      ex_fpu_underflow : std_logic;          -- FPU Exception: underflow
      ex_fpu_inexact : std_logic;            -- FPU Exception: inexact
      trap_irq : std_logic;
      trap_code : std_logic_vector(4 downto 0);
      trap_addr : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
      break_event : std_logic;
      hold_data_store_fault : std_logic;
      hold_data_load_fault : std_logic;
      hold_mbadaddr : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
  end record;

  constant R_RESET : RegistersType := (
        (others => '0'), -- mtvec
        (others => '0'), -- mscratch
        (others => '0'), -- mstackovr
        (others => '0'), -- mstackund
        (others => '0'), -- mbadaddr
        PRV_M,           -- mode
        '0', '0', '0',
        '0',             -- mstackovr_ena
        '0',             -- mstackund_ena
        (others => '0'), (others => '0'), '0',
        '0', '0', '0', '0', '0', 
        '0', (others => '0'), (others => '0'), '0',
        '0', '0', (others => '0'));

  signal r, rin : RegistersType;
  
  procedure procedure_RegAccess(
     iaddr  : in std_logic_vector(11 downto 0);
     iwena  : in std_logic;
     iwdata : in std_logic_vector(RISCV_ARCH-1 downto 0);
     ir : in RegistersType;
     ov : out RegistersType;
     ordata : out std_logic_vector(RISCV_ARCH-1 downto 0)) is
  begin
    ov := ir;
    ordata := (others => '0');
    case iaddr is
    when CSR_fflags =>
        ordata(0) := ir.ex_fpu_inexact;
        ordata(1) := ir.ex_fpu_underflow;
        ordata(2) := ir.ex_fpu_overflow;
        ordata(3) := ir.ex_fpu_divbyzero;
        ordata(4) := ir.ex_fpu_invalidop;
        if CFG_FPU_ENABLE then
            if iwena = '1' then
                ov.ex_fpu_inexact := iwdata(0);
                ov.ex_fpu_underflow := iwdata(1);
                ov.ex_fpu_overflow := iwdata(2);
                ov.ex_fpu_divbyzero := iwdata(3);
                ov.ex_fpu_invalidop := iwdata(4);
            end if;
        end if;
    when CSR_frm =>
        if CFG_FPU_ENABLE then
            ordata(2 downto 0) := "100";  -- Round mode: round to Nearest (RMM)
        end if;
    when CSR_fcsr =>
        ordata(0) := ir.ex_fpu_inexact;
        ordata(1) := ir.ex_fpu_underflow;
        ordata(2) := ir.ex_fpu_overflow;
        ordata(3) := ir.ex_fpu_divbyzero;
        ordata(4) := ir.ex_fpu_invalidop;
        if CFG_FPU_ENABLE then
            ordata(7 downto 5) := "100";  -- Round mode: round to Nearest (RMM)
            if iwena = '1' then
                ov.ex_fpu_inexact := iwdata(0);
                ov.ex_fpu_underflow := iwdata(1);
                ov.ex_fpu_overflow := iwdata(2);
                ov.ex_fpu_divbyzero := iwdata(3);
                ov.ex_fpu_invalidop := iwdata(4);
            end if;
        end if;
    when CSR_misa =>
        --! Base[XLEN-1:XLEN-2]
        --!     1 = 32
        --!     2 = 64
        --!     3 = 128
        --!
        ordata(RISCV_ARCH-1 downto RISCV_ARCH-2) := "10";
        --! BitCharacterDescription
        --! 0  A Atomic extension
        --! 1  B Tentatively reserved for Bit operations extension
        --! 2  C Compressed extension
        --! 3  D Double-precision Foating-point extension
        --! 4  E RV32E base ISA (embedded)
        --! 5  F Single-precision Foating-point extension
        --! 6  G Additional standard extensions present
        --! 7  H Hypervisor mode implemented
        --! 8  I RV32I/64I/128I base ISA
        --! 9  J Reserved
        --! 10 K Reserved
        --! 11 L Tentatively reserved for Decimal Floating-Point extension
        --! 12 M Integer Multiply/Divide extension
        --! 13 N User-level interrupts supported
        --! 14 O Reserved
        --! 15 P Tentatively reserved for Packed-SIMD extension
        --! 16 Q Quad-precision Foating-point extension
        --! 17 R Reserved
        --! 18 S Supervisor mode implemented
        --! 19 T Tentatively reserved for Transactional Memory extension
        --! 20 U User mode implemented
        --! 21 V Tentatively reserved for Vector extension
        --! 22 W Reserved
        --! 23 X Non-standard extensions present
        --! 24 Y Reserved
        --! 25 Z Reserve
        --!
        ordata(8) := '1';
        ordata(12) := '1';
        ordata(20) := '1';
        ordata(2) := '1';
        if CFG_FPU_ENABLE then
            ordata(3) := '1';
        end if;
    when CSR_mvendorid =>
        ordata(31 downto 0) := CFG_VENDOR_ID;
    when CSR_marchid =>
    when CSR_mimplementationid =>
        ordata(31 downto 0) := CFG_IMPLEMENTATION_ID;
    when CSR_mhartid =>
        ordata(31 downto 0) := conv_std_logic_vector(hartid, 32);
    when CSR_uepc =>    -- User mode program counter
    when CSR_mstatus => -- Machine mode status register
        ordata(0) := ir.uie;
        ordata(3) := ir.mie;
        ordata(7) := ir.mpie;
        ordata(12 downto 11) := ir.mpp;
        if CFG_FPU_ENABLE then
            ordata(14 downto 13) := "01";  -- FS field: Initial state
        end if;
        ordata(33 downto 32) := "10";  -- UXL: User mode supported 64-bits
        if iwena = '1' then
            ov.uie := iwdata(0);
            ov.mie := iwdata(3);
            ov.mpie := iwdata(7);
            ov.mpp := iwdata(12 downto 11);
        end if;
    when CSR_medeleg => -- Machine exception delegation
    when CSR_mideleg => -- Machine interrupt delegation
    when CSR_mie =>     -- Machine interrupt enable bit
    when CSR_mtvec =>
        ordata := ir.mtvec;
        if iwena = '1' then
            ov.mtvec := iwdata;
        end if;
    when CSR_mtimecmp => -- Machine wall-clock timer compare value
    when CSR_mscratch => -- Machine scratch register
        ordata := ir.mscratch;
        if iwena = '1' then
            ov.mscratch := iwdata;
        end if;
    when CSR_mepc => -- Machine program counter
        ordata := ir.mepc;
        if iwena = '1' then
            ov.mepc := iwdata;
        end if;
    when CSR_mcause => -- Machine trap cause
        ordata(63) := ir.trap_irq;
        ordata(4 downto 0) := ir.trap_code;
    when CSR_mbadaddr =>   -- Machine bad address
        ordata(BUS_ADDR_WIDTH-1 downto 0) := ir.mbadaddr;
    when CSR_mip =>        -- Machine interrupt pending
    when CSR_mstackovr =>  -- Machine stack overflow
        ordata(BUS_ADDR_WIDTH-1 downto 0) := ir.mstackovr;
        if iwena = '1' then
            ov.mstackovr := iwdata(BUS_ADDR_WIDTH-1 downto 0);
            ov.mstackovr_ena := or_reduce(iwdata(BUS_ADDR_WIDTH-1 downto 0));
        end if;
    when CSR_mstackund =>  -- Machine stack underflow
        ordata(BUS_ADDR_WIDTH-1 downto 0) := ir.mstackund;
        if iwena = '1' then
            ov.mstackund := iwdata(BUS_ADDR_WIDTH-1 downto 0);
            ov.mstackund_ena := or_reduce(iwdata(BUS_ADDR_WIDTH-1 downto 0));
        end if;
    when others =>
    end case;
  end;

begin

  comb : process(i_nrst, i_mret, i_uret, i_sp, i_addr, i_wena, i_wdata, i_trap_ready,
                 i_ex_pc, i_ex_npc, i_ex_data_addr, i_ex_data_load_fault, i_ex_data_store_fault,
                 i_ex_data_store_fault_addr,
                 i_ex_instr_load_fault, i_ex_illegal_instr, i_ex_unalign_load, i_ex_unalign_store,
                 i_ex_breakpoint, i_ex_ecall, 
                 i_ex_fpu_invalidop, i_ex_fpu_divbyzero, i_ex_fpu_overflow,
                 i_ex_fpu_underflow, i_ex_fpu_inexact, i_fpu_valid, i_irq_external,
                 i_break_mode, i_dport_ena, i_dport_write, i_dport_addr, i_dport_wdata,
                 r)
    variable tv1, tv2, v : RegistersType;
    variable wb_rdata : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_dport_rdata : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable w_ie : std_logic;
    variable w_ext_irq : std_logic;
    variable w_dport_wena : std_logic;
    variable w_trap_valid : std_logic;
    variable wb_trap_pc : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    variable w_trap_irq : std_logic;
    variable w_exception_xret : std_logic;
    variable wb_trap_code : std_logic_vector(4 downto 0);
    variable wb_mbadaddr : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    variable w_mstackovr : std_logic;
    variable w_mstackund : std_logic;
  begin

    tv1 := r;

    w_dport_wena := i_dport_ena and i_dport_write;

    procedure_RegAccess(i_addr, i_wena, i_wdata,
                        tv1, tv2, wb_rdata);

    procedure_RegAccess(i_dport_addr, w_dport_wena,
                        i_dport_wdata, tv2, v, wb_dport_rdata);

    w_ie := '0';
    if (r.mode /= PRV_M) or r.mie = '1' then
        w_ie := '1';
    end if;
    w_ext_irq := i_irq_external and w_ie;
    if i_trap_ready = '1' then
        v.ext_irq := w_ext_irq;
    end if;

    w_exception_xret := '0';
    if (i_mret = '1' and r.mode /= PRV_M) or
        (i_uret = '1' and r.mode /= PRV_U) then
        w_exception_xret := '1';
    end if;

    w_mstackovr := '0';
    if i_sp(BUS_ADDR_WIDTH-1 downto 0) < r.mstackovr then
        w_mstackovr := '1';
    end if;

    w_mstackund := '0';
    if i_sp(BUS_ADDR_WIDTH-1 downto 0) > r.mstackund then
        w_mstackund := '1';
    end if;

    if i_fpu_valid = '1' then
        v.ex_fpu_invalidop := i_ex_fpu_invalidop;
        v.ex_fpu_divbyzero := i_ex_fpu_divbyzero;
        v.ex_fpu_overflow := i_ex_fpu_overflow;
        v.ex_fpu_underflow := i_ex_fpu_underflow;
        v.ex_fpu_inexact := i_ex_fpu_inexact;
    end if;

    w_trap_valid := '0';
    w_trap_irq := '0';
    wb_trap_code := (others => '0');
    v.break_event := '0';
    wb_trap_pc := r.mtvec(BUS_ADDR_WIDTH-1 downto 0);
    wb_mbadaddr := i_ex_pc;

    if i_ex_instr_load_fault = '1' then
        w_trap_valid := '1';
        wb_trap_pc := CFG_NMI_INSTR_FAULT_ADDR;
        wb_trap_code := EXCEPTION_InstrFault;
        -- illegal address instruction can generate any other exceptions
        v.hold_data_load_fault := '0';
        v.hold_data_store_fault := '0';
    elsif i_ex_illegal_instr = '1' or w_exception_xret = '1' then
        w_trap_valid := '1';
        wb_trap_pc := CFG_NMI_INSTR_ILLEGAL_ADDR;
        wb_trap_code := EXCEPTION_InstrIllegal;
        -- illegal instruction can generate any other exceptions
        v.hold_data_load_fault := '0';
        v.hold_data_store_fault := '0';
    elsif i_ex_breakpoint = '1' then
        v.break_event := '1';
        w_trap_valid := '1';
        wb_trap_code := EXCEPTION_Breakpoint;
        if i_break_mode = '0' then
            wb_trap_pc := i_ex_pc;
        else
            wb_trap_pc := CFG_NMI_BREAKPOINT_ADDR;
        end if;
    elsif i_ex_unalign_load = '1' then
        w_trap_valid := '1';
        wb_trap_pc := CFG_NMI_LOAD_UNALIGNED_ADDR;
        wb_trap_code := EXCEPTION_LoadMisalign;
    elsif i_ex_data_load_fault = '1' or r.hold_data_load_fault = '1' then
        w_trap_valid := '1';
        v.hold_data_load_fault := '0';
        if i_trap_ready = '0' then
            v.hold_data_load_fault := '1';
        end if;
        wb_trap_pc := CFG_NMI_LOAD_FAULT_ADDR;
        if i_ex_data_load_fault = '1'  then
            wb_mbadaddr := i_ex_data_addr;     -- miss-access read data address
            v.hold_mbadaddr := i_ex_data_addr;
        else
            wb_mbadaddr := r.hold_mbadaddr;
        end if;
        wb_trap_code := EXCEPTION_LoadFault;
    elsif i_ex_unalign_store = '1' then
        w_trap_valid := '1';
        wb_trap_pc := CFG_NMI_STORE_UNALIGNED_ADDR;
        wb_trap_code := EXCEPTION_StoreMisalign;
    elsif i_ex_data_store_fault = '1' or r.hold_data_store_fault = '1' then
        w_trap_valid := '1';
        v.hold_data_store_fault := '0';
        if i_trap_ready = '0' then
            v.hold_data_store_fault := '1';
        end if;
        wb_trap_pc := CFG_NMI_STORE_FAULT_ADDR;
        if i_ex_data_store_fault = '1' then
            wb_mbadaddr := i_ex_data_store_fault_addr;     -- miss-access write data address
            v.hold_mbadaddr := i_ex_data_store_fault_addr;
        else
            wb_mbadaddr := r.hold_mbadaddr;
        end if;
        wb_trap_code := EXCEPTION_StoreFault;
    elsif i_ex_ecall = '1' then
        w_trap_valid := '1';
        if r.mode = PRV_M then
            wb_trap_pc := CFG_NMI_CALL_FROM_MMODE_ADDR;
            wb_trap_code := EXCEPTION_CallFromMmode;
        else
            wb_trap_pc := CFG_NMI_CALL_FROM_UMODE_ADDR;
            wb_trap_code := EXCEPTION_CallFromUmode;
        end if;
    elsif r.mstackovr_ena = '1' and w_mstackovr = '1' then
        w_trap_valid := '1';
        wb_trap_pc := CFG_NMI_STACK_OVERFLOW_ADDR;
        wb_trap_code := EXCEPTION_StackOverflow;
        if i_trap_ready = '1' then
            v.mstackovr := (others => '0');
            v.mstackovr_ena := '0';
        end if;
    elsif r.mstackund_ena = '1' and w_mstackund = '1' then
        w_trap_valid := '1';
        wb_trap_pc := CFG_NMI_STACK_UNDERFLOW_ADDR;
        wb_trap_code := EXCEPTION_StackUnderflow;
        if i_trap_ready = '1' then
            v.mstackund := (others => '0');
            v.mstackund_ena := '0';
        end if;
    elsif w_ext_irq = '1' and r.ext_irq = '0' then
        w_trap_valid := '1';
        wb_trap_pc := r.mtvec(BUS_ADDR_WIDTH-1 downto 0);
        wb_trap_code := INTERRUPT_MExternal;
        w_trap_irq := '1';
    end if;

    if i_addr = CSR_mepc and (not w_exception_xret and (i_mret or i_uret)) = '1' then
        -- Switch to previous mode
        v.mie := r.mpie;
        v.mpie := '1';
        v.mode := r.mpp;
        v.mpp := PRV_U;
    end if;

    -- Behaviour on EBREAK instruction defined by 'i_break_mode':
    --     0 = halt;
    --     1 = generate trap
    if (w_trap_valid and i_trap_ready and (i_break_mode or not i_ex_breakpoint)) = '1' then
        v.mie := '0';
        v.mpp := r.mode;
        v.mepc(RISCV_ARCH-1 downto BUS_ADDR_WIDTH) := (others => '0');
        v.mepc(BUS_ADDR_WIDTH-1 downto 0) := i_ex_npc;
        v.mbadaddr := wb_mbadaddr;
        v.trap_code := wb_trap_code;
        v.trap_irq := w_trap_irq;
        v.mode := PRV_M;
        case r.mode is
        when PRV_U =>
            v.mpie := r.uie;
        when PRV_M =>
            v.mpie := r.mie;
        when others =>
        end case;
    end if;


    if not async_reset and i_nrst = '0' then
        v := R_RESET;
    end if;

    o_trap_valid <= w_trap_valid;
    o_trap_pc <= wb_trap_pc;
    o_rdata <= wb_rdata;
    o_dport_rdata <= wb_dport_rdata;
    o_break_event <= r.break_event;
    
    rin <= v;
  end process;

  -- registers:
  regs : process(i_clk, i_nrst)
  begin 
     if async_reset and i_nrst = '0' then
        r <= R_RESET;
     elsif rising_edge(i_clk) then 
        r <= rin;
     end if; 
  end process;

end;
