vlib work
vmap -c
set path_to_quartus C:/intelFPGA_lite/19.1/quartus/bin64/..
vlib lpm_ver
vmap lpm_ver lpm_ver
vlog -work lpm_ver $path_to_quartus/eda/sim_lib/220model.v
vlib altera_mf_ver
vmap altera_mf_ver altera_mf_ver
vlog -work altera_mf_ver $path_to_quartus/eda/sim_lib/altera_mf.v
vlib sgate_ver
vmap sgate_ver sgate_ver
vlog -work sgate_ver $path_to_quartus/eda/sim_lib/sgate.v
vlog  BPSK_Demodulator_Baseband.v
vlog  BPSK_Demodulator.v
vlog  BPSK_Modulator_Baseband.v
vlog  BPSK_Modulator.v
vlog  BPSK_Modulator_Demodulator.v
