#!/bin/bash

TOP=$1
RTL_FILE=$2

if [ -z "$TOP" ] || [ -z "$RTL_FILE" ]; then
    echo "Usage: $0 <top_module> <rtl_file> [additional_rtl_files...]"
    echo "Example: $0 configurable_mac rtl/configurable_mac.sv rtl/configurable_multiplier.sv"
    exit 1
fi

LIB="/home/shrilakshmi/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

mkdir -p results/synthesis results/netlists

READ_FILES=""
for FILE in "${@:2}"; do
    READ_FILES="$READ_FILES read_verilog -sv $FILE;"
done

yosys -p "
$READ_FILES

hierarchy -check -top $TOP

proc
opt
flatten
opt

techmap
opt

abc -liberty $LIB

clean
opt_clean

stat -liberty $LIB

write_verilog -noattr results/netlists/${TOP}_sky130.v
" | tee results/synthesis/${TOP}_sky130.log
