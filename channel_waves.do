onerror {resume}
radix define States{ {
    "work" "",
    -default default
}
radix define States {
    "1'b1" "GOOD",
    "1'b0" "BAD",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /channel_tb/reset
add wave -noupdate -format Analog-Step -height 74 -max 27566.000000000004 -min -31304.0 -radix decimal /channel_tb/channel_input
add wave -noupdate -format Analog-Step -height 74 -max 32656.0 -min -32592.0 -radix decimal /channel_tb/channel_output
add wave -noupdate -divider Noise
add wave -noupdate -format Analog-Step -height 74 -max 5089.9999999999991 -min -6372.0 -radix decimal /channel_tb/CH/good_ch_AWGN
add wave -noupdate -format Analog-Step -height 74 -max 5319.9999999999991 -min -6265.0 -radix decimal /channel_tb/CH/bad_ch_AWGN
add wave -noupdate -divider {Integer Generator}
add wave -noupdate -radix unsigned /channel_tb/CH/INTGEN/data
add wave -noupdate -divider {State Machine}
add wave -noupdate -format Literal -radix States /channel_tb/CH/current_state
add wave -noupdate -divider {New Divider}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37534 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 153
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {37450 ps} {38298 ps}
