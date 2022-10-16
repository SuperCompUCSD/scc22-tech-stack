#!/bin/sh -e

#no args enables all cores
#coreSet sets teh number of enabled cpu cores


[ $# -eq 0 ] && \
	for i in $(seq 1 $(echo $(nproc --all)-1 | bc)); do echo $i; echo 1 > /sys/devices/system/cpu/cpu$i/online; done || \
	for i in $(seq $1 $(echo $(nproc --all)-1 | bc)); do echo $i; echo 0 > /sys/devices/system/cpu/cpu$i/online; done
