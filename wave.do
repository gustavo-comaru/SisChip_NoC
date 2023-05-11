onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clock_rx(0)

add wave -noupdate -group ROUTER_00_00 -color {Blue Violet} /tb/data_in(0)
add wave -noupdate -group ROUTER_00_00 -color {Blue Violet} /tb/rx(0)
add wave -noupdate -group ROUTER_00_00 -color {Blue Violet} /tb/credit_o(0)
add wave -noupdate -group ROUTER_00_00 /tb/data_out(0)
add wave -noupdate -group ROUTER_00_00 /tb/tx(0)
add wave -noupdate -group ROUTER_00_00 /tb/credit_i(0)

add wave -noupdate -group ROUTER_00_01 -color {Blue Violet} /tb/data_in(1)
add wave -noupdate -group ROUTER_00_01 -color {Blue Violet} /tb/rx(1)
add wave -noupdate -group ROUTER_00_01 -color {Blue Violet} /tb/credit_o(1)
add wave -noupdate -group ROUTER_00_01 /tb/data_out(1)
add wave -noupdate -group ROUTER_00_01 /tb/tx(1)
add wave -noupdate -group ROUTER_00_01 /tb/credit_i(1)

add wave -noupdate -group ROUTER_02_00 -color {Blue Violet} /tb/data_in(2)
add wave -noupdate -group ROUTER_02_00 -color {Blue Violet} /tb/rx(2)
add wave -noupdate -group ROUTER_02_00 -color {Blue Violet} /tb/credit_o(2)
add wave -noupdate -group ROUTER_02_00 /tb/data_out(2)
add wave -noupdate -group ROUTER_02_00 /tb/tx(2)
add wave -noupdate -group ROUTER_02_00 /tb/credit_i(2)

add wave -noupdate -group ROUTER_03_00 -color {Blue Violet} /tb/data_in(3)
add wave -noupdate -group ROUTER_03_00 -color {Blue Violet} /tb/rx(3)
add wave -noupdate -group ROUTER_03_00 -color {Blue Violet} /tb/credit_o(3)
add wave -noupdate -group ROUTER_03_00 /tb/data_out(3)
add wave -noupdate -group ROUTER_03_00 /tb/tx(3)
add wave -noupdate -group ROUTER_03_00 /tb/credit_i(3)

add wave -noupdate -group ROUTER_00_01 -color {Blue Violet} /tb/data_in(4)
add wave -noupdate -group ROUTER_00_01 -color {Blue Violet} /tb/rx(4)
add wave -noupdate -group ROUTER_00_01 -color {Blue Violet} /tb/credit_o(4)
add wave -noupdate -group ROUTER_00_01 /tb/data_out(4)
add wave -noupdate -group ROUTER_00_01 /tb/tx(4)
add wave -noupdate -group ROUTER_00_01 /tb/credit_i(4)

add wave -noupdate -group ROUTER_01_01 -color {Blue Violet} /tb/data_in(5)
add wave -noupdate -group ROUTER_01_01 -color {Blue Violet} /tb/rx(5)
add wave -noupdate -group ROUTER_01_01 -color {Blue Violet} /tb/credit_o(5)
add wave -noupdate -group ROUTER_01_01 /tb/data_out(5)
add wave -noupdate -group ROUTER_01_01 /tb/tx(5)
add wave -noupdate -group ROUTER_01_01 /tb/credit_i(5)

add wave -noupdate -group ROUTER_02_01 -color {Blue Violet} /tb/data_in(6)
add wave -noupdate -group ROUTER_02_01 -color {Blue Violet} /tb/rx(6)
add wave -noupdate -group ROUTER_02_01 -color {Blue Violet} /tb/credit_o(6)
add wave -noupdate -group ROUTER_02_01 /tb/data_out(6)
add wave -noupdate -group ROUTER_02_01 /tb/tx(6)
add wave -noupdate -group ROUTER_02_01 /tb/credit_i(6)

add wave -noupdate -group ROUTER_03_01 -color {Blue Violet} /tb/data_in(7)
add wave -noupdate -group ROUTER_03_01 -color {Blue Violet} /tb/rx(7)
add wave -noupdate -group ROUTER_03_01 -color {Blue Violet} /tb/credit_o(7)
add wave -noupdate -group ROUTER_03_01 /tb/data_out(7)
add wave -noupdate -group ROUTER_03_01 /tb/tx(7)
add wave -noupdate -group ROUTER_03_01 /tb/credit_i(7)

add wave -noupdate -group ROUTER_00_02 -color {Blue Violet} /tb/data_in(8)
add wave -noupdate -group ROUTER_00_02 -color {Blue Violet} /tb/rx(8)
add wave -noupdate -group ROUTER_00_02 -color {Blue Violet} /tb/credit_o(8)
add wave -noupdate -group ROUTER_00_02 /tb/data_out(8)
add wave -noupdate -group ROUTER_00_02 /tb/tx(8)
add wave -noupdate -group ROUTER_00_02 /tb/credit_i(8)

add wave -noupdate -group ROUTER_01_02 -color {Blue Violet} /tb/data_in(9)
add wave -noupdate -group ROUTER_01_02 -color {Blue Violet} /tb/rx(9)
add wave -noupdate -group ROUTER_01_02 -color {Blue Violet} /tb/credit_o(9)
add wave -noupdate -group ROUTER_01_02 /tb/data_out(9)
add wave -noupdate -group ROUTER_01_02 /tb/tx(9)
add wave -noupdate -group ROUTER_01_02 /tb/credit_i(9)

add wave -noupdate -group ROUTER_02_02 -color {Blue Violet} /tb/data_in(10)
add wave -noupdate -group ROUTER_02_02 -color {Blue Violet} /tb/rx(10)
add wave -noupdate -group ROUTER_02_02 -color {Blue Violet} /tb/credit_o(10)
add wave -noupdate -group ROUTER_02_02 /tb/data_out(10)
add wave -noupdate -group ROUTER_02_02 /tb/tx(10)
add wave -noupdate -group ROUTER_02_02 /tb/credit_i(10)

add wave -noupdate -group ROUTER_03_02 -color {Blue Violet} /tb/data_in(11)
add wave -noupdate -group ROUTER_03_02 -color {Blue Violet} /tb/rx(11)
add wave -noupdate -group ROUTER_03_02 -color {Blue Violet} /tb/credit_o(11)
add wave -noupdate -group ROUTER_03_02 /tb/data_out(11)
add wave -noupdate -group ROUTER_03_02 /tb/tx(11)
add wave -noupdate -group ROUTER_03_02 /tb/credit_i(11)

add wave -noupdate -group ROUTER_00_03 -color {Blue Violet} /tb/data_in(12)
add wave -noupdate -group ROUTER_00_03 -color {Blue Violet} /tb/rx(12)
add wave -noupdate -group ROUTER_00_03 -color {Blue Violet} /tb/credit_o(12)
add wave -noupdate -group ROUTER_00_03 /tb/data_out(12)
add wave -noupdate -group ROUTER_00_03 /tb/tx(12)
add wave -noupdate -group ROUTER_00_03 /tb/credit_i(12)

add wave -noupdate -group ROUTER_01_03 -color {Blue Violet} /tb/data_in(13)
add wave -noupdate -group ROUTER_01_03 -color {Blue Violet} /tb/rx(13)
add wave -noupdate -group ROUTER_01_03 -color {Blue Violet} /tb/credit_o(13)
add wave -noupdate -group ROUTER_01_03 /tb/data_out(13)
add wave -noupdate -group ROUTER_01_03 /tb/tx(13)
add wave -noupdate -group ROUTER_01_03 /tb/credit_i(13)

add wave -noupdate -group ROUTER_02_03 -color {Blue Violet} /tb/data_in(14)
add wave -noupdate -group ROUTER_02_03 -color {Blue Violet} /tb/rx(14)
add wave -noupdate -group ROUTER_02_03 -color {Blue Violet} /tb/credit_o(14)
add wave -noupdate -group ROUTER_02_03 /tb/data_out(14)
add wave -noupdate -group ROUTER_02_03 /tb/tx(14)
add wave -noupdate -group ROUTER_02_03 /tb/credit_i(14)

add wave -noupdate -group ROUTER_03_03 -color {Blue Violet} /tb/data_in(15)
add wave -noupdate -group ROUTER_03_03 -color {Blue Violet} /tb/rx(15)
add wave -noupdate -group ROUTER_03_03 -color {Blue Violet} /tb/credit_o(15)
add wave -noupdate -group ROUTER_03_03 /tb/data_out(15)
add wave -noupdate -group ROUTER_03_03 /tb/tx(15)
add wave -noupdate -group ROUTER_03_03 /tb/credit_i(15)

TreeUpdate [SetDefaultTree]
quietly wave cursor active 1
configure wave -namecolwidth 249
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 us}

