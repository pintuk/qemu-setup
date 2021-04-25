guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ make defconfig
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ make -j8
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ make menuconfig

BusyBox Settings--> Build Options -> Select Build static binary(no shared libs)
Save it.

guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ make -j8 
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ make install
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ cd _install/
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2/_install$ mkdir proc sys dev etc etc/init.d
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2/_install$ cd etc/init.d/
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2/_install/etc/init.d/$ vi rcS 
{{{
	#!/bin/sh
	
	mount -t proc none /proc
	mount -t sysfs none /sys
	/sbin/mdev -s

}}}
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ cd ../../../ 
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ chmod +x _install/etc/init.d/rcS

guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ cd _install/
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2/_install$ find . | cpio -o --format=newc > ../rootfs.img
4260 blocks
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2/_install$ cd ..
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ gzip -c rootfs.img > rootfs.img.gz
guru@INSISCSDT-2370:~/env_qemu/busybox-1.29.2$ qemu-system-arm -M vexpress-a9 -m 1024M -kernel ../linux/arch/arm/boot/zImage -dtb ../linux/arch/arm/boot/dts/vexpress-v2p-ca9.dtb -initrd rootfs.img.gz -append "console=ttyAMA0 root=/dev/ram rdinit=/sbin/init ip=dhcp" -nographic


