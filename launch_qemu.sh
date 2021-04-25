#/bin/bash

if [ "$1" = "" ]
then
	echo "Usage: busybox | systemd | buildroot"
	exit
fi

if [ "$1" = "busybox" ]
then
echo "Launching : QEMU - with BUSYBOX rootfs....."
qemu-system-arm -M vexpress-a9 -m 256M -kernel ../KERNEL/linux/arch/arm/boot/zImage -dtb ../KERNEL/linux/arch/arm/boot/dts/vexpress-v2p-ca9.dtb -initrd ../BUSYBOX/rootfs.img.gz -append "console=ttyAMA0 root=/dev/ram rdinit=/sbin/init ip=dhcp" -nographic
fi

if [ "$1" = "systemd" ]
then
echo "Launching : QEMU - with rootfs-arm and systemd....."
qemu-system-arm -M vexpress-a9 -m 256M -kernel ../KERNEL/linux/arch/arm/boot/zImage -dtb ../KERNEL/linux/arch/arm/boot/dts/vexpress-v2p-ca9.dtb -append "root=/dev/mmcblk0 rw roottype=ext4 console=ttyAMA0,115200" -drive if=sd,driver=raw,cache=writeback,file=./rootfs-arm/arch_rootfs.ext4 -nographic
fi

