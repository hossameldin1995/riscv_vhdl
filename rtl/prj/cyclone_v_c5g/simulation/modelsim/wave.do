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
add wave -position insertpoint  \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/async_reset \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_nrst \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_clk \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_ena \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_a \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/i_b \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_res \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_illegal_op \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_overflow \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_valid \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/o_busy \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/s_o_res \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/counter_st \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/reset \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/s_o_illegal_op \
sim:/top_c5g/soc0/cpu0/river0/proc0/exec0/fpuena/fpu0/fmul_d0/s_o_busy



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




























