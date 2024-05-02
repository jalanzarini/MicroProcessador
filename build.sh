#!/bin/bash

ghdl -a mux2x1.vhd
ghdl -a mux8x1.vhd
ghdl -a reg16bits.vhd
ghdl -a wr_en_demux.vhd

ghdl -a ula.vhd
ghdl -a registerBank.vhd
ghdl -a microProcessor.vhd

ghdl -e mux2x1
ghdl -e mux8x1
ghdl -e reg16bits
ghdl -e wr_en_demux

ghdl -e ula
ghdl -e registerBank
ghdl -e microProcessor

ghdl -r microProcessor --wave=microProcessor.ghw