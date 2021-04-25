#!/bin/bash

while [ 1 ]
do
	./launch.sh &
	echo "QEMU.....killed"
	sleep 20
	kill -9 launch.sh
	killall -9 qemu-system-riscv64
	sleep 10
done
