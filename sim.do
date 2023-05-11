if {[file isdirectory work]} { vdel -all -lib work }

rm -f ./outputs/*

vlib work
vmap work work

vcom -work work -93 -explicit NOC/Hermes_package.vhd
vcom -work work -93 -explicit NOC/Hermes_buffer.vhd
vcom -work work -93 -explicit NOC/Hermes_switchcontrol.vhd
vcom -work work -93 -explicit NOC/Hermes_crossbar.vhd
vlog -work work NOC/Report_Path.sv
vcom -work work -93 -explicit NOC/RouterCC.vhd
vcom -work work -93 -explicit NOC/NOC.vhd
vlog -work work tb.sv

vsim -t 10ps work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 

run 1 us

exit