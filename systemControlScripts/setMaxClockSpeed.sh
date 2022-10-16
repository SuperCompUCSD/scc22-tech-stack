#!/bin/bash
set -e

echo $1 | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq && grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq
