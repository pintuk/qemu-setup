
#!/bin/sh
DUMPK_CMDLINE="console=ttyAMA0 root=/dev/mmcblk0 rootfstype=ext4 rootwait init=/sbin/init maxcpus=1 reset_devices"
kexec --type zImage \
-p ./zImage \
--dtb=./vexpress-v2p-ca9.dtb \
--append="${DUMPK_CMDLINE}" 
[ $? -ne 0 ] && { 
    echo "kexec failed." ; exit 1
}
echo "$0: kexec: success, dump kernel loaded."
exit 0

