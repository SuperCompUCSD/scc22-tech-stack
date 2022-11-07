#!/bin/bash
#
# This is a script to collect SMART and error logs for Liqid nvme devices.
# Also then continually monitors temperature by default every 12 seconds (5 times per minute)
#
# Suggested usage:
#     ./liqid_nvme_tool.sh /dev/nvme0 /dev/nvme1 /dev/nvme2 /dev/nvme3 /dev/nvme4 /dev/nvme5 /dev/nvme6 /dev/nvme7 > liqid_tool_output.txt & 
# then cat liqid_tool_output.txt or tail -f liqid_tool_output.txt

drives=$#

echo "Liqid NVMe Tool version 1"
echo "Number of drives requested is $drives beginning $(date) "

if [ $drives -gt 8 ]; then
    echo That is too many... exiting
    exit 1
elif [ $drives -eq 8 ]; then
    echo Drives are $1 $2 $3 $4 $5 $6 $7 $8
elif [ $drives -eq 7 ]; then
    echo Drives are $1 $2 $3 $4 $5 $6 $7
elif [ $drives -eq 6 ]; then
    echo Drives are $1 $2 $3 $4 $5 $6
elif [ $drives -eq 5 ]; then
    echo Drives are $1 $2 $3 $4 $5
elif [ $drives -eq 4 ]; then
    echo Drives are $1 $2 $3 $4
elif [ $drives -eq 3 ]; then
    echo Drives are $1 $2 $3
elif [ $drives -eq 2 ]; then
    echo Drives are $1 $2
elif [ $drives -eq 1 ]; then
    echo Drives are $1
else
    echo "Usage: nvme_temperatures.sh <drive path> [drive path] ..."
    exit 2
fi

echo "--------------- lspci (Serial Number)---------"

lspci -vvv | grep Serial

echo "----------------------------------------------"

for drive in "$@"
do
    echo "----- SMART log drive $drive -------------"
    nvme smart-log $drive 
    echo "------------------------------------------"
    echo "----- ERROR log drive $drive -------------"
    nvme error-log $drive 
    echo "------------------------------------------"
done

echo "-------------------- temperature -------------"

while [ 1 ]; do
    for drive in "$@"
    do
        temperature=$(nvme smart-log $drive | grep temperature | awk '{print $3}')

        data+=', '
        data+=$temperature
    done
    date=$(date)
    echo "$date$data"
    data=""
    sleep 12
done

exit
