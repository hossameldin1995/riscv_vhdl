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
use IEEE.std_logic_arith.all;  -- UNSIGNED function
library commonlib;
use commonlib.types_common.all;
--! RIVER CPU specific library.
library riverlib;
--! RIVER CPU configuration constants.
use riverlib.river_cfg.all;

library target;
use target.config_target.all;

entity InstrExecute is generic (
    async_reset : boolean
  );
  port (
    i_clk  : in std_logic;
    i_nrst : in std_logic;                                      -- Reset active LOW
    i_pipeline_hold : in std_logic;                             -- Hold execution by any reason
    i_d_valid : in std_logic;                                   -- Decoded instruction is valid
    i_d_pc : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);    -- Instruction pointer on decoded instruction
    i_d_instr : in std_logic_vector(31 downto 0);               -- Decoded instruction value
    i_wb_ready : in std_logic;                                  -- End of write back operation
    i_memop_store : in std_logic;                               -- Store to memory operation
    i_memop_load : in std_logic;                                -- Load from memoru operation
    i_memop_sign_ext : in std_logic;                            -- Load memory value with sign extending
    i_memop_size : in std_logic_vector(1 downto 0);             -- Memory transaction size
    i_unsigned_op : in std_logic;                               -- Unsigned operands
    i_rv32 : in std_logic;                                      -- 32-bits instruction
    i_compressed : in std_logic;                                -- C-extension (2-bytes length)
    i_f64 : in std_logic;                                       -- D-extension (FPU)
    i_isa_type : in std_logic_vector(ISA_Total-1 downto 0);     -- Type of the instruction's structure (ISA spec.)
    i_ivec : in std_logic_vector(Instr_Total-1 downto 0);       -- One pulse per supported instruction.
    i_unsup_exception : in std_logic;                           -- Unsupported instruction exception
    i_instr_load_fault : in std_logic;                          -- Instruction fetched from fault address
    i_dport_npc_write : in std_logic;                           -- Write npc value from debug port
    i_dport_npc : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);-- Debug port npc value to write

    o_radr1 : out std_logic_vector(5 downto 0);                 -- Integer/float register index 1
    i_rdata1 : in std_logic_vector(RISCV_ARCH-1 downto 0);      -- Integer register value 1
    o_radr2 : out std_logic_vector(5 downto 0);                 -- Integer/float register index 2
    i_rdata2 : in std_logic_vector(RISCV_ARCH-1 downto 0);      -- Integer register value 2
    i_rfdata1 : in std_logic_vector(RISCV_ARCH-1 downto 0);     -- Float register value 1
    i_rfdata2 : in std_logic_vector(RISCV_ARCH-1 downto 0);     -- Float register value 2
    o_res_addr : out std_logic_vector(5 downto 0);              -- Address to store result of the instruction (0=do not store)
    o_res_data : out std_logic_vector(RISCV_ARCH-1 downto 0);   -- Value to store
    o_pipeline_hold : out std_logic;                            -- Hold pipeline while 'writeback' not done or multi-clock instruction.
    o_csr_addr : out std_logic_vector(11 downto 0);             -- CSR address. 0 if not a CSR instruction with xret signals mode switching
    o_csr_wena : out std_logic;                                 -- Write new CSR value
    i_csr_rdata : in std_logic_vector(RISCV_ARCH-1 downto 0);   -- CSR current value
    o_csr_wdata : out std_logic_vector(RISCV_ARCH-1 downto 0);  -- CSR new value
    i_trap_valid : in std_logic;
    i_trap_pc : in std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    -- exceptions:
    o_ex_npc : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    o_ex_instr_load_fault : out std_logic;                      -- Instruction fetched from fault address
    o_ex_illegal_instr : out std_logic;
    o_ex_unalign_store : out std_logic;
    o_ex_unalign_load : out std_logic;
    o_ex_breakpoint : out std_logic;
    o_ex_ecall : out std_logic;
    o_ex_fpu_invalidop : out std_logic;            -- FPU Exception: invalid operation
    o_ex_fpu_divbyzero : out std_logic;            -- FPU Exception: divide by zero
    o_ex_fpu_overflow : out std_logic;             -- FPU Exception: overflow
    o_ex_fpu_underflow : out std_logic;            -- FPU Exception: underflow
    o_ex_fpu_inexact : out std_logic;              -- FPU Exception: inexact
    o_fpu_valid : out std_logic;                   -- FPU output is valid

    o_memop_sign_ext : out std_logic;                           -- Load data with sign extending
    o_memop_load : out std_logic;                               -- Load data instruction
    o_memop_store : out std_logic;                              -- Store data instruction
    o_memop_size : out std_logic_vector(1 downto 0);            -- 0=1bytes; 1=2bytes; 2=4bytes; 3=8bytes
    o_memop_addr : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);-- Memory access address

    o_trap_ready : out std_logic;                               -- Trap branch request was accepted
    o_valid : out std_logic;                                    -- Output is valid
    o_pc : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);     -- Valid instruction pointer
    o_npc : out std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);    -- Next instruction pointer. Next decoded pc must match to this value or will be ignored.
    o_instr : out std_logic_vector(31 downto 0);                -- Valid instruction value
    o_call : out std_logic;                                     -- CALL pseudo instruction detected
    o_ret : out std_logic;                                      -- RET pseudoinstruction detected
    o_mret : out std_logic;                                     -- MRET instruction
    o_uret : out std_logic                                      -- URET instruction
  );
end; 
 
architecture arch_InstrExecute of InstrExecute is

  constant Multi_MUL : integer := 0;
  constant Multi_DIV : integer := 1;
  constant Multi_FPU : integer := 2;
  constant Multi_Total : integer := 3;

  constant State_WaitInstr : std_logic_vector(2 downto 0) := "000";
  constant State_SingleCycle : std_logic_vector(2 downto 0) := "001";
  constant State_MultiCycle : std_logic_vector(2 downto 0) := "010";
  constant State_Hold : std_logic_vector(2 downto 0) := "011";
  constant State_Hazard : std_logic_vector(2 downto 0) := "100";

  constant zero64 : std_logic_vector(63 downto 0) := (others => '0');

  type multi_arith_type is array (0 to Multi_Total-1) 
      of std_logic_vector(RISCV_ARCH-1 downto 0);

  type RegistersType is record
        state : std_logic_vector(2 downto 0);
        d_valid : std_logic;                                   -- Valid decoded instruction latch
        pc : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
        npc : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
        instr : std_logic_vector(31 downto 0);
        res_addr : std_logic_vector(5 downto 0);
        res_val : std_logic_vector(RISCV_ARCH-1 downto 0);
        memop_load : std_logic;
        memop_store : std_logic;
        memop_sign_ext : std_logic;
        memop_size : std_logic_vector(1 downto 0);
        memop_addr : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);

        multi_res_addr : std_logic_vector(5 downto 0);         -- latched output reg. address while multi-cycle instruction
        multi_pc : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);-- latched pc-value while multi-cycle instruction
        multi_npc : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);-- latched npc-value while multi-cycle instruction
        multi_instr : std_logic_vector(31 downto 0);           -- Multi-cycle instruction is under processing
        multi_ena : std_logic_vector(Multi_Total-1 downto 0);  -- Enable pulse for Operation that takes more than 1 clock
        multi_rv32 : std_logic;                                -- Long operation with 32-bits operands
        multi_f64 : std_logic;                                 -- Long float operation
        multi_unsigned : std_logic;                            -- Long operation with unsiged operands
        multi_residual_high : std_logic;                       -- Flag for Divider module: 0=divsion output; 1=residual output
                                                               -- Flag for multiplier: 0=usual; 1=get high bits
        multiclock_ena : std_logic;
        multi_ivec_fpu : std_logic_vector(Instr_FPU_Total-1 downto 0);
        multi_a1 : std_logic_vector(RISCV_ARCH-1 downto 0);    -- Multi-cycle operand 1
        multi_a2 : std_logic_vector(RISCV_ARCH-1 downto 0);    -- Multi-cycle operand 2

        hazard_addr0 : std_logic_vector(5 downto 0);           -- Updated register address on previous step
        hazard_depth : std_logic_vector(1 downto 0);           -- Number of modificated registers that wasn't done yet
        hold_valid : std_logic;
        hold_multi_ena : std_logic;

        call : std_logic;
        ret : std_logic;
  end record;

  constant R_RESET : RegistersType := (
    State_WaitInstr,                                   -- state
    '0', (others => '0'), CFG_NMI_RESET_VECTOR,        -- d_valid, pc, npc
    (others => '0'), (others => '0'), (others => '0'), -- instr, res_addr, res_val
    '0', '0', '0', "00", (others => '0'),              -- memop_load, memop_store, memop_sign_ext, memop_size, memop_addr
    (others => '0'), (others => '0'), (others => '0'), -- multi_res_addr, multi_pc, multi_npc
    (others => '0'), (others => '0'), '0',             -- multi_instr, multi_ena, multi_rv32
    '0', '0',  '0',                                    -- multi_f64, multi_unsigned, multi_residual_high
    '0', (others => '0'),                              -- multiclock_ena, multi_ivec_fpu
    (others => '0'), (others => '0'),                  -- multi_a1, multi_a2
    (others => '0'), (others => '0'),                  -- hazard_add0, hazard_depth
    '0', '0',                                          -- hold_valid, hold_multi_ena
    '0', '0'                                           -- call, ret
  );

  signal r, rin : RegistersType;

  signal wb_arith_res : multi_arith_type;
  signal w_arith_valid : std_logic_vector(Multi_Total-1 downto 0);
  signal w_arith_busy : std_logic_vector(Multi_Total-1 downto 0);

  signal wb_shifter_a1 : std_logic_vector(RISCV_ARCH-1 downto 0);  -- Shifters operand 1
  signal wb_shifter_a2 : std_logic_vector(5 downto 0);             -- Shifters operand 2
  signal wb_sll : std_logic_vector(RISCV_ARCH-1 downto 0);
  signal wb_sllw : std_logic_vector(RISCV_ARCH-1 downto 0);
  signal wb_srl : std_logic_vector(RISCV_ARCH-1 downto 0);
  signal wb_srlw : std_logic_vector(RISCV_ARCH-1 downto 0);
  signal wb_sra : std_logic_vector(RISCV_ARCH-1 downto 0);
  signal wb_sraw : std_logic_vector(RISCV_ARCH-1 downto 0);
  
 component IntMulCycloneV is generic (
    async_reset : boolean
  );
  port (
    i_clk  : in std_logic;
    i_nrst : in std_logic;
    i_ena : in std_logic;
    i_unsigned : in std_logic;
    i_high : in std_logic;
    i_rv32 : in std_logic;
    i_a1 : in std_logic_vector(RISCV_ARCH-1 downto 0);
    i_a2 : in std_logic_vector(RISCV_ARCH-1 downto 0);
    o_res : out std_logic_vector(RISCV_ARCH-1 downto 0);
    o_valid : out std_logic;
    o_busy : out std_logic
  );
  end component;

  component IntDiv is generic (
    async_reset : boolean
  );
  port (
    i_clk  : in std_logic;
    i_nrst : in std_logic;
    i_ena : in std_logic;
    i_unsigned : in std_logic;
    i_rv32 : in std_logic;
    i_residual : in std_logic;
    i_a1 : in std_logic_vector(RISCV_ARCH-1 downto 0);
    i_a2 : in std_logic_vector(RISCV_ARCH-1 downto 0);
    o_res : out std_logic_vector(RISCV_ARCH-1 downto 0);
    o_valid : out std_logic;
    o_busy : out std_logic
  );
  end component;
  
  component Shifter is port (
    i_a1 : in std_logic_vector(RISCV_ARCH-1 downto 0);
    i_a2 : in std_logic_vector(5 downto 0);
    o_sll : out std_logic_vector(RISCV_ARCH-1 downto 0);
    o_sllw : out std_logic_vector(RISCV_ARCH-1 downto 0);
    o_srl : out std_logic_vector(RISCV_ARCH-1 downto 0);
    o_sra : out std_logic_vector(RISCV_ARCH-1 downto 0);
    o_srlw : out std_logic_vector(RISCV_ARCH-1 downto 0);
    o_sraw : out std_logic_vector(RISCV_ARCH-1 downto 0)
  );
  end component;

  component FpuTop is 
  generic (
    async_reset : boolean
  );
  port (
    i_nrst         : in std_logic;
    i_clk          : in std_logic;
    i_ena          : in std_logic;
    i_ivec         : in std_logic_vector(Instr_FPU_Total-1 downto 0);
    i_a            : in std_logic_vector(63 downto 0);
    i_b            : in std_logic_vector(63 downto 0);
    o_res          : out std_logic_vector(63 downto 0);
    o_ex_invalidop : out std_logic;   -- Exception: invalid operation
    o_ex_divbyzero : out std_logic;   -- Exception: divide by zero
    o_ex_overflow  : out std_logic;   -- Exception: overflow
    o_ex_underflow : out std_logic;   -- Exception: underflow
    o_ex_inexact   : out std_logic;   -- Exception: inexact
    o_valid        : out std_logic;
    o_busy         : out std_logic
  );
  end component; 

begin
   
   mul_ena : if CFG_MUL_ENABLE generate
      mul0 : IntMulCycloneV generic map (
			async_reset => async_reset
		) port map (
			i_clk  => i_clk,
			i_nrst => i_nrst,
			i_ena => r.multi_ena(Multi_MUL),
			i_unsigned => r.multi_unsigned,
			i_high => r.multi_residual_high,
			i_rv32 => r.multi_rv32,
			i_a1 => r.multi_a1,
			i_a2 => r.multi_a2,
			o_res => wb_arith_res(Multi_MUL),
			o_valid => w_arith_valid(Multi_MUL),
			o_busy => w_arith_busy(Multi_MUL)
		);
   end generate;

   mul_dis : if not CFG_MUL_ENABLE generate
      wb_arith_res(Multi_MUL)		<= (others => '0');
		w_arith_valid(Multi_MUL)	<= '0';
		w_arith_busy(Multi_MUL)		<= '0';
   end generate;

   div0 : IntDiv generic map (
      async_reset => async_reset
   ) port map (
      i_clk  => i_clk,
      i_nrst => i_nrst,
      i_ena => r.multi_ena(Multi_DIV),
      i_unsigned => r.multi_unsigned,
      i_residual => r.multi_residual_high,
      i_rv32 => r.multi_rv32,
      i_a1 => r.multi_a1,
      i_a2 => r.multi_a2,
      o_res => wb_arith_res(Multi_DIV),
      o_valid => w_arith_valid(Multi_DIV),
      o_busy => w_arith_busy(Multi_DIV));
      
  sh0 : Shifter port map (
      i_a1 => wb_shifter_a1,
      i_a2 => wb_shifter_a2,
      o_sll => wb_sll,
      o_sllw => wb_sllw,
      o_srl => wb_srl,
      o_sra => wb_sra,
      o_srlw => wb_srlw,
      o_sraw => wb_sraw);

  fpuena : if CFG_FPU_ENABLE generate
     fpu0 : FpuTop generic map (
        async_reset => async_reset
     ) port map (
        i_clk => i_clk,
        i_nrst => i_nrst,
        i_ena => r.multi_ena(Multi_FPU),
        i_ivec => r.multi_ivec_fpu,
        i_a => r.multi_a1,
        i_b => r.multi_a2,
        o_res => wb_arith_res(Multi_FPU),
        o_ex_invalidop => o_ex_fpu_invalidop,
        o_ex_divbyzero => o_ex_fpu_divbyzero,
        o_ex_overflow => o_ex_fpu_overflow,
        o_ex_underflow => o_ex_fpu_underflow,
        o_ex_inexact => o_ex_fpu_inexact,
        o_valid => w_arith_valid(Multi_FPU),
        o_busy => w_arith_busy(Multi_FPU)
     );
  end generate;

  fpudis : if not CFG_FPU_ENABLE generate
        wb_arith_res(Multi_FPU) <= (others => '0');
        w_arith_valid(Multi_FPU) <= '0';
        w_arith_busy(Multi_FPU) <= '0';
        o_fpu_valid <= '0';
        o_ex_fpu_invalidop <= '0';
        o_ex_fpu_divbyzero <= '0';
        o_ex_fpu_overflow <= '0';
        o_ex_fpu_underflow <= '0';
        o_ex_fpu_inexact <= '0';
  end generate;

  comb : process(i_nrst, i_pipeline_hold, i_d_valid, i_d_pc, i_d_instr,
                 i_wb_ready, i_memop_load, i_memop_store, i_memop_sign_ext,
                 i_memop_size, i_unsigned_op, i_rv32, i_compressed, i_f64, i_isa_type, i_ivec,
                 i_rdata1, i_rdata2, i_rfdata1, i_rfdata2, i_csr_rdata, 
                 i_trap_valid, i_trap_pc, i_dport_npc_write,
                 i_dport_npc, i_unsup_exception, i_instr_load_fault,
                 wb_arith_res, w_arith_valid, w_arith_busy,
                 wb_sll, wb_sllw, wb_srl, wb_srlw, wb_sra, wb_sraw, r)
    variable v : RegistersType;
    variable w_exception_store : std_logic;
    variable w_exception_load : std_logic;
    variable wb_radr1 : std_logic_vector(5 downto 0);      -- [5] 0=Integer bank; 1=FPU bank
    variable wb_rdata1 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_radr2 : std_logic_vector(5 downto 0);
    variable wb_rdata2 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable w_mret : std_logic;
    variable w_uret : std_logic;
    variable w_csr_wena : std_logic;
    variable wb_res_addr : std_logic_vector(5 downto 0);
    variable wb_csr_addr  : std_logic_vector(11 downto 0);
    variable wb_csr_wdata : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_res : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_npc : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    variable wb_ex_npc : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);
    variable wb_off : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_mask_i31 : std_logic_vector(RISCV_ARCH-1 downto 0);    -- Bits depending instr[31] bits
    variable wb_sum64 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_sum32 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_sub64 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_sub32 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_and64 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_or64 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable wb_xor64 : std_logic_vector(RISCV_ARCH-1 downto 0);
    variable w_memop_load : std_logic;
    variable w_memop_store : std_logic;
    variable w_memop_sign_ext : std_logic;
    variable wb_memop_size : std_logic_vector(1 downto 0);
    variable wb_memop_addr : std_logic_vector(BUS_ADDR_WIDTH-1 downto 0);

    variable w_valid : std_logic;
    variable w_pc_valid : std_logic;
    variable w_next_ready : std_logic;
    variable w_hold : std_logic;
    variable w_multi_valid : std_logic;
    variable w_multi_ena : std_logic;
    variable w_fpu_ena : std_logic;
    variable w_res_wena : std_logic;
    variable w_pc_branch : std_logic;
    variable w_hazard_lvl1 : std_logic;
    variable w_hazard_lvl2 : std_logic;
    variable w_less : std_logic;
    variable w_gr_equal : std_logic;
    variable wv : std_logic_vector(Instr_Total-1 downto 0);
    variable opcode_len : integer;

  begin

    wb_radr1 := (others => '0');
    wb_radr2 := (others => '0');
    w_mret := '0';
    w_uret := '0';
    w_csr_wena := '0';
    wb_res_addr := (others => '0');
    wb_csr_addr := (others => '0');
    wb_csr_wdata := (others => '0');
    wb_res := (others => '0');
    wb_off := (others => '0');
    wb_rdata1 := (others => '0');
    wb_rdata2 := (others => '0');
    w_memop_load := '0';
    w_memop_store := '0';
    w_memop_sign_ext := '0';
    wb_memop_size := (others => '0');
    wb_memop_addr := (others => '0');
    wv := i_ivec;

    v := r;

    wb_mask_i31 := (others => i_d_instr(31));

    w_pc_valid := '0';
    if i_d_pc = r.npc then
        w_pc_valid := '1';
    end if;

    if i_isa_type(ISA_R_type) = '1' then
        wb_radr1 := ('0' & i_d_instr(19 downto 15));
        wb_rdata1 := i_rdata1;
        wb_radr2 := ('0' & i_d_instr(24 downto 20));
        wb_rdata2 := i_rdata2;
        if CFG_FPU_ENABLE and i_f64 = '1' then
            if (wv(Instr_FMOV_D_X) or
                wv(Instr_FCVT_D_L) or wv(Instr_FCVT_D_LU) or
                wv(Instr_FCVT_D_W) or wv(Instr_FCVT_D_WU)) = '0' then
                wb_radr1 := ('1' & i_d_instr(19 downto 15));
                wb_rdata1 := i_rfdata1;
            end if;
            if wv(Instr_FMOV_X_D) = '0' then
                wb_radr2 := ('1' & i_d_instr(24 downto 20));
                wb_rdata2 := i_rfdata2;
            end if;
        end if;
    elsif i_isa_type(ISA_I_type) = '1' then
        wb_radr1 := ('0' & i_d_instr(19 downto 15));
        wb_rdata1 := i_rdata1;
        wb_radr2 := (others => '0');
        wb_rdata2 := wb_mask_i31(63 downto 12) & i_d_instr(31 downto 20);
    elsif i_isa_type(ISA_SB_type) = '1' then
        wb_radr1 := ('0' & i_d_instr(19 downto 15));
        wb_rdata1 := i_rdata1;
        wb_radr2 := ('0' & i_d_instr(24 downto 20));
        wb_rdata2 := i_rdata2;
        wb_off(RISCV_ARCH-1 downto 12) := wb_mask_i31(RISCV_ARCH-1 downto 12);
        wb_off(12) := i_d_instr(31);
        wb_off(11) := i_d_instr(7);
        wb_off(10 downto 5) := i_d_instr(30 downto 25);
        wb_off(4 downto 1) := i_d_instr(11 downto 8);
        wb_off(0) := '0';
    elsif i_isa_type(ISA_UJ_type) = '1' then
        wb_radr1 := (others => '0');
        wb_rdata1 := X"00000000" & i_d_pc;
        wb_radr2 := (others => '0');
        wb_off(RISCV_ARCH-1 downto 20) := wb_mask_i31(RISCV_ARCH-1 downto 20);
        wb_off(19 downto 12) := i_d_instr(19 downto 12);
        wb_off(11) := i_d_instr(20);
        wb_off(10 downto 1) := i_d_instr(30 downto 21);
        wb_off(0) := '0';
    elsif i_isa_type(ISA_U_type) = '1'then
        wb_radr1 := (others => '0');
        wb_rdata1 := X"00000000" & i_d_pc;
        wb_radr2 := (others => '0');
        wb_rdata2(31 downto 0) := i_d_instr(31 downto 12) & X"000";
        wb_rdata2(RISCV_ARCH-1 downto 32) := wb_mask_i31(RISCV_ARCH-1 downto 32);
    elsif i_isa_type(ISA_S_type) = '1' then
        wb_radr1 := ('0' & i_d_instr(19 downto 15));
        wb_rdata1 := i_rdata1;
        wb_radr2 := ('0' & i_d_instr(24 downto 20));
        wb_rdata2 := i_rdata2;
        wb_off(RISCV_ARCH-1 downto 12) := wb_mask_i31(RISCV_ARCH-1 downto 12);
        wb_off(11 downto 5) := i_d_instr(31 downto 25);
        wb_off(4 downto 0) := i_d_instr(11 downto 7);
        if CFG_FPU_ENABLE and wv(Instr_FSD) = '1' then
            wb_radr2 := ('1' & i_d_instr(24 downto 20));
            wb_rdata2 := i_rfdata2;
        end if;
    end if;

    --! Default number of cycles per instruction = 0 (1 clock per instr)
    --! If instruction is multicycle then modify this value.
    --!
    w_fpu_ena := '0';
    if CFG_FPU_ENABLE then
        if i_f64 = '1' and (wv(Instr_FSD) or wv(Instr_FLD)) = '0' then
            w_fpu_ena := '1';
        end if;
    end if;

    w_multi_ena := wv(Instr_MUL) or wv(Instr_MULW) or wv(Instr_DIV)
                    or wv(Instr_DIVU) or wv(Instr_DIVW) or wv(Instr_DIVUW)
                    or wv(Instr_REM) or wv(Instr_REMU) or wv(Instr_REMW)
                    or wv(Instr_REMUW) or w_fpu_ena;

    w_multi_valid := w_arith_valid(Multi_MUL) or w_arith_valid(Multi_DIV)
                   or w_arith_valid(Multi_FPU);

    -- Don't modify registers on conditional jumps:
    w_res_wena := not (wv(Instr_BEQ) or wv(Instr_BGE) or wv(Instr_BGEU)
               or wv(Instr_BLT) or wv(Instr_BLTU) or wv(Instr_BNE)
               or wv(Instr_SD) or wv(Instr_SW) or wv(Instr_SH) or wv(Instr_SB)
               or wv(Instr_FSD)
               or wv(Instr_MRET) or wv(Instr_URET)
               or wv(Instr_ECALL) or wv(Instr_EBREAK));

    if w_multi_valid = '1' then
        wb_res_addr := r.multi_res_addr;
        v.multiclock_ena := '0';
    elsif w_res_wena = '1' then
        wb_res_addr := ('0' & i_d_instr(11 downto 7));
        if CFG_FPU_ENABLE then
            if i_f64 = '1' and wv(Instr_FLD) = '1' then
                wb_res_addr(5) := '1';
            end if;
        end if;
    else
        wb_res_addr := (others => '0');
    end if;


    w_next_ready := '0';
    w_hold := '0';

    if i_d_valid = '1' and w_pc_valid = '1' then
        w_next_ready := '1';
    end if;

    --! Valid values on the inputs radr1,radr2 will be 2 cycles after
    --! signal o_valid = 1
    --!
    w_hazard_lvl1 := '0';
    if r.res_addr /= "000000" and
        (wb_radr1 = r.res_addr or wb_radr2 = r.res_addr) then
        w_hazard_lvl1 := '1';
    end if;

    w_hazard_lvl2 := '0';
    if r.hazard_addr0 /= "000000" and
        (wb_radr1 = r.hazard_addr0 or wb_radr2 = r.hazard_addr0) then
        w_hazard_lvl2 := '1';
    end if;

    w_valid := '0';
    case r.state is
    when State_WaitInstr =>
        if r.hazard_depth /= "00" and w_hazard_lvl2 = '1' then
            -- Hazard after missed predicted instruction 1 cycle
            w_hold := '1';
            w_next_ready := '0';
        elsif i_pipeline_hold = '1' then
            v.state := State_Hold;
            v.hold_valid := w_next_ready;
            v.hold_multi_ena := w_multi_ena;
        elsif w_next_ready = '1' then
            if w_multi_ena = '1' then
                w_hold := '1';
                v.state := State_MultiCycle;
            else
                v.state := State_SingleCycle;
            end if;
        end if;
    when State_SingleCycle =>
        w_valid := '1';
        if w_hazard_lvl1 = '1' then
            -- 2-cycles wait state
            w_hold := '1';
            w_next_ready := '0';
            v.state := State_Hazard;
        elsif w_hazard_lvl2 = '1' then
            -- 1-cycle wait state
            w_hold := '1';
            w_next_ready := '0';
            if i_wb_ready = '1' then
                v.state := State_WaitInstr;
            else
                -- Queue in memaccess module allows to accept 2 LOAD instructions
                v.state := State_Hazard;
            end if;
        elsif i_pipeline_hold = '1' then
            v.state := State_Hold;
            v.hold_valid := w_next_ready;
            v.hold_multi_ena := w_multi_ena;
        elsif w_next_ready = '1' then
            if w_multi_ena = '1' then
                w_hold := '1';
                v.state := State_MultiCycle;
            else
                v.state := State_SingleCycle;
            end if;
        else
            v.state := State_WaitInstr;
        end if;
    when State_MultiCycle =>
        w_hold := '1';
        w_next_ready := '0';
        if w_multi_valid = '1' then
            v.state := State_SingleCycle;
        end if;
    when State_Hold =>
        --! No need to raise w_hold because it is already hold, but we have
        --! to use previously latched values of instruction type because outputs
        --! pc and npc switched for next instruction
        w_next_ready := '0';
        if i_pipeline_hold = '0' then
            if r.hold_valid = '1' then
                if r.hold_multi_ena = '1' and w_multi_valid = '0' then
                    v.state := State_MultiCycle;
                else
                    v.state := State_SingleCycle;
                end if;
            else
                v.state := State_WaitInstr;
            end if;
        elsif r.hold_multi_ena = '1' then
            --! Track the end of multi-instruction while in Hold state
            if w_multi_valid = '1' then
                v.hold_multi_ena := '0';
            end if;
        end if;
    when State_Hazard =>
        w_next_ready := '0';
        w_hold := '1';
        if i_wb_ready = '1' then
            v.state := State_WaitInstr;
        end if;
    when others =>
    end case;

    if w_valid = '1' then
        v.hazard_addr0 := r.res_addr;
    end if;

    if w_valid = '1' and i_wb_ready = '0' then
        v.hazard_depth := r.hazard_depth + 1;
    elsif w_valid = '0' and i_wb_ready = '1' then
        v.hazard_depth := r.hazard_depth - 1;
    end if;


    -- parallel ALU:
    wb_sum64 := wb_rdata1 + wb_rdata2;
    wb_sum32(31 downto 0) := wb_rdata1(31 downto 0) + wb_rdata2(31 downto 0);
    wb_sum32(63 downto 32) := (others => wb_sum32(31));
    wb_sub64 := wb_rdata1 - wb_rdata2;
    wb_sub32(31 downto 0) := wb_rdata1(31 downto 0) - wb_rdata2(31 downto 0);
    wb_sub32(63 downto 32) := (others => wb_sub32(31));
    wb_and64 := wb_rdata1 and wb_rdata2;
    wb_or64 := wb_rdata1 or wb_rdata2;
    wb_xor64 := wb_rdata1 xor wb_rdata2;
    
    wb_shifter_a1 <= wb_rdata1;
    wb_shifter_a2 <= wb_rdata2(5 downto 0);

    w_less := '0';
    w_gr_equal := '0';
    if UNSIGNED(wb_rdata1) < UNSIGNED(wb_rdata2) then
        w_less := '1';
    end if;
    if UNSIGNED(wb_rdata1) >= UNSIGNED(wb_rdata2) then
        w_gr_equal := '1';
    end if;

    -- Relative Branch on some condition:
    w_pc_branch := '0';
    if ((wv(Instr_BEQ) = '1' and (wb_sub64 = zero64))
        or (wv(Instr_BGE) = '1' and (wb_sub64(63) = '0'))
        or (wv(Instr_BGEU) = '1' and (w_gr_equal = '1'))
        or (wv(Instr_BLT) = '1' and (wb_sub64(63) = '1'))
        or (wv(Instr_BLTU) = '1' and (w_less = '1'))
        or (wv(Instr_BNE) = '1' and (wb_sub64 /= zero64))) then
        w_pc_branch := '1';
    end if;

    opcode_len := 4;
    if i_compressed = '1' then
        opcode_len := 2;
    end if;

    if w_pc_branch = '1' then
        wb_npc := i_d_pc + wb_off(BUS_ADDR_WIDTH-1 downto 0);
    elsif wv(Instr_JAL) = '1' then
        wb_res(63 downto 32) := (others => '0');
        wb_res(31 downto 0) := i_d_pc + opcode_len;
        wb_npc := wb_rdata1(BUS_ADDR_WIDTH-1 downto 0) + wb_off(BUS_ADDR_WIDTH-1 downto 0);
    elsif wv(Instr_JALR) = '1' then
        wb_res(63 downto 32) := (others => '0');
        wb_res(31 downto 0) := i_d_pc + opcode_len;
        wb_npc := wb_rdata1(BUS_ADDR_WIDTH-1 downto 0) + wb_rdata2(BUS_ADDR_WIDTH-1 downto 0);
        wb_npc(0) := '0';
    elsif wv(Instr_MRET) = '1' then
        wb_res(63 downto 32) := (others => '0');
        wb_res(31 downto 0) := i_d_pc + opcode_len;
        w_mret := '1';
        w_csr_wena := '0';
        wb_csr_addr := CSR_mepc;
        wb_npc := i_csr_rdata(BUS_ADDR_WIDTH-1 downto 0);
    elsif wv(Instr_URET) = '1' then
        wb_res(63 downto 32) := (others => '0');
        wb_res(31 downto 0) := i_d_pc + opcode_len;
        w_uret := '1';
        w_csr_wena := '0';
        wb_csr_addr := CSR_uepc;
        wb_npc := i_csr_rdata(BUS_ADDR_WIDTH-1 downto 0);
    else
        -- Instr_HRET, Instr_SRET, Instr_FENCE, Instr_FENCE_I:
        wb_npc := i_d_pc + opcode_len;
    end if;

    if i_memop_load = '1' then
        wb_memop_addr := wb_rdata1(BUS_ADDR_WIDTH-1 downto 0)
                      + wb_rdata2(BUS_ADDR_WIDTH-1 downto 0);
    elsif i_memop_store = '1' then
        wb_memop_addr := wb_rdata1(BUS_ADDR_WIDTH-1 downto 0)
                       + wb_off(BUS_ADDR_WIDTH-1 downto 0);
    end if;

    w_exception_store := '0';
    w_exception_load := '0';

    if ((wv(Instr_LD) = '1' and wb_memop_addr(2 downto 0) /= "000")
        or ((wv(Instr_LW) or wv(Instr_LWU)) = '1' and wb_memop_addr(1 downto 0) /= "00")
        or ((wv(Instr_LH) or wv(Instr_LHU)) = '1' and wb_memop_addr(0) /= '0'))  then
        w_exception_load := '1';
    end if;
    if ((wv(Instr_SD) = '1' and wb_memop_addr(2 downto 0) /= "000")
        or (wv(Instr_SW) = '1' and wb_memop_addr(1 downto 0) /= "00")
        or (wv(Instr_SH) = '1' and wb_memop_addr(0) /= '0')) then
        w_exception_store := '1';
    end if;

    v.multi_ena := (others => '0');
    v.multi_rv32 := i_rv32;
    v.multi_f64 := i_f64;
    v.multi_unsigned := i_unsigned_op;
    v.multi_residual_high := '0';
    if w_fpu_ena = '1' then
        v.multi_a1 := wb_rdata1;
        v.multi_a2 := wb_rdata2;
    else
        v.multi_a1 := i_rdata1;
        v.multi_a2 := i_rdata2;
    end if;

    if (w_multi_ena and w_next_ready) = '1' then
        v.multiclock_ena := '1';
        v.multi_res_addr := wb_res_addr;
        if CFG_FPU_ENABLE then
            v.multi_ivec_fpu := wv(Instr_FSGNJ_D downto Instr_FADD_D);
            if w_fpu_ena = '1' and (wv(Instr_FMOV_X_D) or wv(Instr_FEQ_D)
                or wv(Instr_FLT_D) or wv(Instr_FLE_D)
                or wv(Instr_FCVT_LU_D) or wv(Instr_FCVT_L_D)
                or wv(Instr_FCVT_WU_D) or wv(Instr_FCVT_W_D)) = '0' then
                v.multi_res_addr := '1' & wb_res_addr(4 downto 0);
            end if;
        end if;
        v.multi_pc := i_d_pc;
        v.multi_instr := i_d_instr;
        if i_trap_valid = '1' then
            v.multi_npc := i_trap_pc;
        else
            v.multi_npc := wb_npc;
        end if;
    end if;


    -- ALU block selector:
    if w_arith_valid(Multi_MUL) = '1' then
        wb_res := wb_arith_res(Multi_MUL);
    elsif w_arith_valid(Multi_DIV) = '1' then
        wb_res := wb_arith_res(Multi_DIV);
    elsif w_arith_valid(Multi_FPU) = '1' then
        wb_res := wb_arith_res(Multi_FPU);
    elsif i_memop_load = '1' then
        w_memop_load := '1';
        w_memop_sign_ext := i_memop_sign_ext;
        wb_memop_size := i_memop_size;
    elsif i_memop_store = '1' then
        w_memop_store := '1';
        wb_memop_size := i_memop_size;
        wb_res := wb_rdata2;
    elsif (wv(Instr_ADD) or wv(Instr_ADDI) or wv(Instr_AUIPC)) = '1' then
        wb_res := wb_sum64;
    elsif (wv(Instr_ADDW) or wv(Instr_ADDIW)) = '1' then
        wb_res := wb_sum32;
    elsif wv(Instr_SUB) = '1' then
        wb_res := wb_sub64;
    elsif wv(Instr_SUBW) = '1' then
        wb_res := wb_sub32;
    elsif (wv(Instr_SLL) or wv(Instr_SLLI)) = '1' then
        wb_res := wb_sll;
    elsif (wv(Instr_SLLW) or wv(Instr_SLLIW)) = '1' then
        wb_res := wb_sllw;
    elsif (wv(Instr_SRL) or wv(Instr_SRLI)) = '1' then
        wb_res := wb_srl;
    elsif (wv(Instr_SRLW) or wv(Instr_SRLIW)) = '1' then
        wb_res := wb_srlw;
    elsif (wv(Instr_SRA) or wv(Instr_SRAI)) = '1' then
        wb_res := wb_sra;
    elsif (wv(Instr_SRAW) or wv(Instr_SRAW) or wv(Instr_SRAIW)) = '1' then
        wb_res := wb_sraw;
    elsif (wv(Instr_AND) or wv(Instr_ANDI)) = '1' then
        wb_res := wb_and64;
    elsif (wv(Instr_OR) or wv(Instr_ORI)) = '1' then
        wb_res := wb_or64;
    elsif (wv(Instr_XOR) or wv(Instr_XORI)) = '1' then
        wb_res := wb_xor64;
    elsif (wv(Instr_SLT) or wv(Instr_SLTI)) = '1' then
        wb_res(RISCV_ARCH-1 downto 1) := (others => '0');
        wb_res(0) := wb_sub64(63);
    elsif (wv(Instr_SLTU) or wv(Instr_SLTIU)) = '1' then
        wb_res(63 downto 1) := (others => '0');
        wb_res(0) := w_less;
    elsif wv(Instr_LUI) = '1' then
        wb_res := wb_rdata2;
    elsif (wv(Instr_MUL) or wv(Instr_MULW)) = '1' then
        v.multi_ena(Multi_MUL) := w_next_ready;
    elsif (wv(Instr_DIV) or wv(Instr_DIVU)
            or wv(Instr_DIVW) or wv(Instr_DIVUW)) = '1' then
        v.multi_ena(Multi_DIV) := w_next_ready;
    elsif (wv(Instr_REM) or wv(Instr_REMU)
            or wv(Instr_REMW) or wv(Instr_REMUW)) = '1' then
        v.multi_ena(Multi_DIV) := w_next_ready;
        v.multi_residual_high := '1';
    elsif w_fpu_ena = '1' then
        v.multi_ena(Multi_FPU) := w_next_ready;
    elsif wv(Instr_CSRRC) = '1' then
        wb_res := i_csr_rdata;
        w_csr_wena := '1';
        wb_csr_addr := wb_rdata2(11 downto 0);
        wb_csr_wdata := i_csr_rdata and (not i_rdata1);
    elsif wv(Instr_CSRRCI) = '1' then
        wb_res := i_csr_rdata;
        w_csr_wena := '1';
        wb_csr_addr := wb_rdata2(11 downto 0);
        wb_csr_wdata(RISCV_ARCH-1 downto 5) := i_csr_rdata(RISCV_ARCH-1 downto 5);
        wb_csr_wdata(4 downto 0) := i_csr_rdata(4 downto 0) and not wb_radr1(4 downto 0);  -- zero-extending 5 to 64-bits
    elsif wv(Instr_CSRRS) = '1' then
        wb_res := i_csr_rdata;
        w_csr_wena := '1';
        wb_csr_addr := wb_rdata2(11 downto 0);
        wb_csr_wdata := i_csr_rdata or i_rdata1;
    elsif wv(Instr_CSRRSI) = '1' then
        wb_res := i_csr_rdata;
        w_csr_wena := '1';
        wb_csr_addr := wb_rdata2(11 downto 0);
        wb_csr_wdata(RISCV_ARCH-1 downto 5) := i_csr_rdata(RISCV_ARCH-1 downto 5);
        wb_csr_wdata(4 downto 0) := i_csr_rdata(4 downto 0) or wb_radr1(4 downto 0);  -- zero-extending 5 to 64-bits
    elsif wv(Instr_CSRRW) = '1' then
        wb_res := i_csr_rdata;
        w_csr_wena := '1';
        wb_csr_addr := wb_rdata2(11 downto 0);
        wb_csr_wdata := i_rdata1;
    elsif wv(Instr_CSRRWI) = '1' then
        wb_res := i_csr_rdata;
        w_csr_wena := '1';
        wb_csr_addr := wb_rdata2(11 downto 0);
        wb_csr_wdata(RISCV_ARCH-1 downto 5) := (others => '0');
        wb_csr_wdata(4 downto 0) := wb_radr1(4 downto 0);  -- zero-extending 5 to 64-bits
    end if;


    o_trap_ready <= w_next_ready;

    o_ex_instr_load_fault <= i_instr_load_fault and w_next_ready;
    o_ex_illegal_instr <= i_unsup_exception and w_next_ready;
    o_ex_unalign_store <= w_exception_store and w_next_ready;
    o_ex_unalign_load <= w_exception_load and w_next_ready;
    o_ex_breakpoint <= wv(Instr_EBREAK) and w_next_ready;
    o_ex_ecall <= wv(Instr_ECALL) and w_next_ready;

    v.call := '0';
    v.ret := '0';
    wb_ex_npc := (others => '0');
    if i_dport_npc_write = '1' then
        v.npc := i_dport_npc;
    elsif w_multi_valid = '1' then
        -- multi-cycle instruction ending by single-cycle state
        -- so no need to check jump opcodes
        v.pc := r.multi_pc;
        v.instr := r.multi_instr;
        v.npc := r.multi_npc;
        v.memop_load := '0';
        v.memop_sign_ext := '0';
        v.memop_store := '0';
        v.memop_size := (others => '0');
        v.memop_addr := (others => '0');

        v.res_addr := wb_res_addr;
        v.res_val := wb_res;
    elsif w_next_ready = '1' then
        v.pc := i_d_pc;
        v.instr := i_d_instr;
        if i_trap_valid = '1' then
            v.npc := i_trap_pc;
            wb_ex_npc := wb_npc;
        else
            v.npc := wb_npc;
        end if;
        v.memop_load := w_memop_load;
        v.memop_sign_ext := w_memop_sign_ext;
        v.memop_store := w_memop_store;
        v.memop_size := wb_memop_size;
        v.memop_addr := wb_memop_addr;

        v.res_addr := wb_res_addr;
        v.res_val := wb_res;

        if wv(Instr_JAL) = '1' and conv_integer(wb_res_addr) = Reg_ra then
            v.call := '1';
        end if;
        if wv(Instr_JALR) = '1' then
            if conv_integer(wb_res_addr) = Reg_ra then
                v.call := '1';
            elsif wb_rdata2 = zero64 and conv_integer(wb_radr1) = Reg_ra then
                v.ret := '1';
            end if;
        end if;
    end if;

    if not async_reset and i_nrst = '0' then
        v := R_RESET;
    end if;

    o_radr1 <= wb_radr1;
    o_radr2 <= wb_radr2;
    o_res_addr <= r.res_addr;
    o_res_data <= r.res_val;
    o_pipeline_hold <= w_hold;

    o_csr_wena <= w_csr_wena and w_next_ready;
    o_csr_addr <= wb_csr_addr;
    o_csr_wdata <= wb_csr_wdata;
    o_ex_npc <= wb_ex_npc;

    o_memop_sign_ext <= r.memop_sign_ext;
    o_memop_load <= r.memop_load;
    o_memop_store <= r.memop_store;
    o_memop_size <= r.memop_size;
    o_memop_addr <= r.memop_addr;

    o_valid <= w_valid;
    o_pc <= r.pc;
    o_npc <= r.npc;
    o_instr <= r.instr;
    o_call <= r.call;
    o_ret <= r.ret;
    o_mret <= w_mret;
    o_uret <= w_uret;
    o_fpu_valid <= w_arith_valid(Multi_FPU);
    
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
