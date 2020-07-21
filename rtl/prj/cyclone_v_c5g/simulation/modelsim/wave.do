restart

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_c5g/CLOCK_125_p
add wave -noupdate /top_c5g/CPU_RESET_n
add wave -noupdate /top_c5g/i_rst
add wave -noupdate /top_c5g/GPIO_IN
add wave -noupdate /top_c5g/GPIO_OUT
add wave -noupdate /top_c5g/LEDG
add wave -noupdate /top_c5g/LEDR
add wave -noupdate /top_c5g/SW
add wave -noupdate /top_c5g/KEY
add wave -noupdate /top_c5g/UART_RX
add wave -noupdate /top_c5g/UART_TX
add wave -noupdate /top_c5g/w_ext_reset
add wave -noupdate /top_c5g/w_clk_bus
add wave -noupdate /top_c5g/w_pll_lock
add wave -noupdate /top_c5g/soc0/i_rst
add wave -noupdate /top_c5g/soc0/i_clk
add wave -noupdate /top_c5g/soc0/w_glob_rst
add wave -noupdate /top_c5g/soc0/w_glob_nrst
add wave -noupdate /top_c5g/soc0/w_soft_rst
add wave -noupdate /top_c5g/soc0/w_bus_nrst
add wave -noupdate /top_c5g/soc0/aximi
add wave -noupdate /top_c5g/soc0/aximo
add wave -noupdate /top_c5g/soc0/axisi
add wave -noupdate /top_c5g/soc0/axiso
add wave -noupdate /top_c5g/soc0/w_ext_irq
add wave -noupdate /top_c5g/soc0/dport_i
add wave -noupdate /top_c5g/soc0/dport_o
add wave -noupdate /top_c5g/soc0/wb_bus_util_w
add wave -noupdate /top_c5g/soc0/wb_bus_util_r
add wave -noupdate /top_c5g/soc0/irq_pins
add wave -noupdate /top_c5g/soc0/cpu0/river0/proc0/w
add wave -noupdate /top_c5g/soc0/cpu0/river0/proc0/iregs0/r
add wave -noupdate /top_c5g/soc0/cpu0/river0/proc0/iregs0/rin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 258
configure wave -valuecolwidth 138
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1597184 ps}


###################################################################
############################# FPU ADD #############################
###################################################################
#add wave -position insertpoint  \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_nrst \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_clk \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_ena \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_add \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_sub \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_eq \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_lt \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_le \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_max \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_min \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_a \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/i_b \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/o_res \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/o_illegal_op \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/o_overflow \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/o_valid \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/o_busy \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/reset \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/s_o_res \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/res_add_sub \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/res_eq \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/res_lt \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/res_le \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/res_max \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/counter_st \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/en_stage \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/en_add_sub \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/en_eq \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/en_lt \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/en_le \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/en_max_min \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/opSel \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/s_o_illegal_op \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fadd_d0/s_o_valid


###################################################################
############################# FPU MUL #############################
###################################################################
#add wave -position insertpoint  \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/async_reset \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_nrst \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_clk \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_ena \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_a \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_b \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_res \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_illegal_op \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_overflow \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_valid \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_busy \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/s_o_res \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/counter_st \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/reset \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/s_o_illegal_op \
#sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/s_o_busy


add wave -position insertpoint  \
sim:/top_c5g/soc0/cpu0/river0/proc0/fpuena/fregs0/r \
sim:/top_c5g/soc0/cpu0/river0/proc0/fpuena/fregs0/rin




add wave -position insertpoint  \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/async_reset \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_clk \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_nrst \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_pipeline_hold \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_d_valid \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_d_pc \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_d_instr \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_wb_ready \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_memop_store \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_memop_load \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_memop_sign_ext \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_memop_size \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_unsigned_op \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_rv32 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_compressed \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_f64 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_isa_type \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_ivec \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_unsup_exception \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_instr_load_fault \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_dport_npc_write \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_dport_npc \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_radr1 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_rdata1 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_radr2 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_rdata2 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_rfdata1 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_rfdata2 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_res_addr \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_res_data \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_pipeline_hold \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_csr_addr \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_csr_wena \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_csr_rdata \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_csr_wdata \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_trap_valid \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/i_trap_pc \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_npc \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_instr_load_fault \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_illegal_instr \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_unalign_store \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_unalign_load \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_breakpoint \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_ecall \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_fpu_invalidop \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_fpu_divbyzero \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_fpu_overflow \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_fpu_underflow \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ex_fpu_inexact \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_fpu_valid \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_memop_sign_ext \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_memop_load \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_memop_store \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_memop_size \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_memop_addr \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_trap_ready \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_valid \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_pc \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_npc \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_instr \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_call \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_ret \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_mret \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/o_uret \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/r \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/rin \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_arith_res \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/w_arith_valid \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/w_arith_busy \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_shifter_a1 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_shifter_a2 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_sll \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_sllw \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_srl \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_srlw \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_sra \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/wb_sraw \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/Multi_MUL \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/Multi_DIV \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/Multi_FPU \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/Multi_Total \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/State_WaitInstr \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/State_SingleCycle \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/State_MultiCycle \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/State_Hold \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/State_Hazard \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/zero64 \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/R_RESET






force -freeze sim:/top_c5g/SW 0 0
force -freeze sim:/top_c5g/KEY 0 0
force -freeze sim:/top_c5g/UART_RX 0 0
force -freeze sim:/top_c5g/soc0/GPIO_IN 0 0
force -freeze sim:/top_c5g/CLOCK_125_p 1 0, 0 {4000 ps} -r 8000
force -freeze sim:/top_c5g/CPU_RESET_n 0 0

run
run
run
run
run
run

force -freeze sim:/top_c5g/CPU_RESET_n 1 0

run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run




























