#!/bin/bash

# Components 
ghdl -a components/mux2x1.vhd
ghdl -a components/mux8x1.vhd
ghdl -a components/reg16bits.vhd
ghdl -a components/wr_en_demux.vhd

ghdl -a components/stateMachine.vhd
ghdl -a components/controlUnit.vhd
ghdl -a components/programCounter.vhd
ghdl -a components/rom.vhd

ghdl -a components/ula.vhd
ghdl -a components/registerBank.vhd
ghdl -a components/lab4.vhd
ghdl -a components/processador.vhd

ghdl -e mux2x1
ghdl -e mux8x1
ghdl -e reg16bits
ghdl -e wr_en_demux

ghdl -e oneStateMachine
ghdl -e controlUnit
ghdl -e programCounter
ghdl -e rom

ghdl -e ula
ghdl -e registerBank
ghdl -e lab4
ghdl -e processador

# Test benches
ghdl -a ula_tb.vhd
ghdl -a reg16bits_tb.vhd
ghdl -a registerBank_tb.vhd
ghdl -a rom_tb.vhd

ghdl -a lab4_tb.vhd
ghdl -a processador_tb.vhd

ghdl -e ula_tb
ghdl -e reg16bits_tb
ghdl -e registerBank_tb
ghdl -e rom_tb

ghdl -e lab4_tb
ghdl -e processador_tb

ghdl -r ula_tb --wave=waves/ula_tb.ghw
ghdl -r reg16bits_tb --wave=waves/reg16bits_tb.ghw
ghdl -r registerBank_tb --wave=waves/registerBank_tb.ghw
ghdl -r rom_tb --wave=waves/rom_tb.ghw

ghdl -r lab4_tb --wave=waves/lab4_tb.ghw
ghdl -r processador_tb --wave=waves/processador_tb.ghw