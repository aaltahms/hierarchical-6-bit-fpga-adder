#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")/.."
mkdir -p build
cd build
sources="../rtl/half_adder.vhd ../rtl/full_adder.vhd ../rtl/ripple_carry_adder.vhd ../rtl/seven_segment_display.vhd ../rtl/adder_top.vhd ../sim/tb_ripple_carry_adder.vhd"
if command -v ghdl >/dev/null 2>&1; then
 for source in $sources; do ghdl -a --std=08 "$source"; done
 ghdl -e --std=08 tb_ripple_carry_adder
 ghdl -r --std=08 tb_ripple_carry_adder --assert-level=error
elif command -v nvc >/dev/null 2>&1; then
 nvc --std=2008 -a $sources
 nvc --std=2008 -e tb_ripple_carry_adder -r --exit-severity=error
else
 echo "Install GHDL or NVC." >&2; exit 127
fi
