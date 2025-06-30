vlib work
vlog D_mux_SYNC.v D_mux_ASYNC.v DSP48A1.v
vsim -voptargs=+acc work.test_DSP48A1
add wave *
run -all
#quit -sim