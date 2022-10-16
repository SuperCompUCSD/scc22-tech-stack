#!/bin/bash

#no args enables all cores
#coreSet sets teh number of enabled cpu cores

[ $# -eq 0 ] && \
	echo 1 | eval sudo tee /sys/devices/system/cpu/cpu{1..$(echo $(nproc --all)-1 | bc)}/online || \
	echo 0 | eval sudo tee /sys/devices/system/cpu/cpu{$1..$(echo $(nproc --all)-1 | bc)}/online



