#!/bin/bash

qemu-system-riscv64 -nographic -machine virt -kernel PK/riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0,115200" -drive file=busybear.bin,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -m 1024M -smp 4

