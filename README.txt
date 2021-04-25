1.	RISCV TOOLCHAIN -->

:~/riscv$ git clone https://github.com/riscv/riscv-gnu-toolchain.git
:~/riscv$ cd riscv-gnu-toolchain/
:~/riscv/riscv-gnu-toolchain$ git submodule update --init --recursive
:~/riscv/riscv-gnu-toolchain$ ./configure --prefix=/opt/riscv 

:~/riscv/riscv-gnu-toolchain$ sudo make linux



2.	Building the riscv-linux kernel and creating the BBL image for qemu booting -->

:~/riscv$ https://github.com/riscv/riscv-linux.git 
:~/riscv/riscv-linux$ make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- defconfig
:~/riscv/riscv-linux$ make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- -j8
:~/riscv/riscv-linux$ riscv64-unknown-linux-gnu-strip -o vmlinux-stripped vmlinux
:~/riscv/riscv-linux$ cd ../riscv-pk
:~/riscv/riscv-pk$ mkdir build
:~/riscv/riscv-pk$ cd build/
:~/riscv/riscv-pk/build$ ../configure --enable-logo --host=riscv64-unknown-linux-gnu --with-payload=../../riscv-linux/vmlinux-stripped
:~/riscv/riscv-pk/build$ make -j8

BBL image is inside riscv-pk/build



3.	RISCV-QEMU BINARIES -->

:~/riscv/riscv-qemu$ git submodule update --init --recursive
:~/riscv/riscv-qemu$ ./configure --target-list=riscv64-softmmu,riscv32-softmmu
:~/riscv/riscv-qemu$ make -j8
:~/riscv/riscv-qemu$ make install




4.	BUSYBEAR -->

Required packages :- riscv-linux, riscv-gnu-toolchain, riscv-pk, busybear-linux

:~/guru_test/7_nofree$ git clone https://github.com/michaeljclark/busybear-linux.git
:~/guru_test/7_nofree$ cd busybear-linux
:~/guru_test/7_nofree/busybear-linux$ make -j8
:~/guru_test/7_nofree/busybear-linux$ cd ../riscv-gnu-toolchain/riscv-qemu
:~/guru_test/7_nofree/riscv-gnu-toolchain/riscv-qemu$ ./configure --target-list=riscv64-softmmu,riscv32-softmmu
:~/guru_test/7_nofree/riscv-gnu-toolchain/riscv-qemu$ make -j8
:~/guru_test/7_nofree/riscv-gnu-toolchain/riscv-qemu$ make install
:~/guru_test/7_nofree/riscv-gnu-toolchain/riscv-qemu$ cd ../../riscv-linux
:~/guru_test/7_nofree/riscv-linux$ cp ../busybear-linux/conf/linux.config .config
:~/guru_test/7_nofree/riscv-linux$ make ARCH=riscv defconfig
:~/guru_test/7_nofree/riscv-linux$ make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- vmlinux -j8
:~/guru_test/7_nofree/riscv-linux$ riscv64-unknown-linux-gnu-strip -o vmlinux-stripped vmlinux
:~/guru_test/7_nofree/riscv-linux$ cd ../riscv-pk
:~/guru_test/7_nofree/riscv-pk$ mkdir build
:~/guru_test/7_nofree/riscv-pk$ cd build
:~/guru_test/7_nofree/riscv-pk/build$ ../configure --enable-logo --host=riscv64-unknown-linux-gnu --with-payload=../../riscv-linux/vmlinux-stripped
:~/guru_test/7_nofree/riscv-pk/build$ make -j8
:~/guru_test/7_nofree/riscv-pk/build$ cd ../../riscv-gnu-toolchain/riscv-qemu
:~/guru_test/7_nofree/riscv-gnu-toolchain/riscv-qemu$ sudo qemu-system-riscv64 -nographic -machine virt -kernel ../../riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0" -drive file=../../busybear-linux/busybear.bin,format=raw,id=hd0 -device virtio-blk-device,drive=hd0

Linux version 4.18.0-rc6-13938-g4060877-dirty (guru@INSISCSDT-2370) (gcc version 7.2.0 (GCC)) #1 SMP Fri Aug 17 16:29:53 IST 2018
bootconsole [early0] enabled
(none) login: root
Password: busybear




5.	DEBIAN_ROOTFS -->

guru@INSISCSDT-2370:~/newrootfs$ ls
riscv_debian_rootfs.tar.gz 
guru@INSISCSDT-2370:~/newrootfs$ dd if=/dev/zero of=riscv-ext4.bin bs=5G count=1
guru@INSISCSDT-2370:~/newrootfs$ ls
riscv_debian_rootfs.tar.gz  riscv-ext4.bin
guru@INSISCSDT-2370:~/newrootfs$ mkfs.ext4 -F -m0 riscv-ext4.bin 
guru@INSISCSDT-2370:~/newrootfs$ sudo mount -t ext4 riscv-ext4.bin /mnt -o loop 
guru@INSISCSDT-2370:~/newrootfs$ cd /mnt/
guru@INSISCSDT-2370:~/mnt$ sudo tar -xzvf ~/practice/riscv_debian_rootfs.tar.gz 
guru@INSISCSDT-2370:~/mnt$ ls
lost+found  tmp
guru@INSISCSDT-2370:~/mnt$ sudo mv tmp/riscv64-chroot/* .
mv: cannot move 'tmp/riscv64-chroot/tmp' to './tmp': Directory not empty
guru@INSISCSDT-2370:~/mnt$ ls
bin  boot  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
guru@INSISCSDT-2370:~/mnt$ ls tmp/riscv64-chroot/tmp/
guru@INSISCSDT-2370:~/mnt$ rm -rf tmp/
rm: cannot remove 'tmp/riscv64-chroot/tmp': Permission denied
guru@INSISCSDT-2370:~/mnt$ sudo rm -rf tmp/
guru@INSISCSDT-2370:~/mnt$ sudo mkdir tmp
guru@INSISCSDT-2370:~/mnt$ ls
bin  boot  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
guru@INSISCSDT-2370:~/riscv/riscv-qemu$ qemu-system-riscv64 -nographic -machine virt -kernel ../riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0" -drive file=~/newrootfs/riscv-ext4.bin,format=raw,id=hd0 -device virtio-blk-device,drive=hd0


6.	LTP for RISCV -->

guru@INSISCSDT-2370:~/guru_test$ git clone https://github.com/linux-test-project/ltp.git
guru@INSISCSDT-2370:~/guru_test/ltp$ make ARCH=riscv autotools
guru@INSISCSDT-2370:~/guru_test/ltp$ ./configure ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- --host=riscv64-unknown-linux-gnu CC=riscv64-unknown-linux-gnu-gcc 
guru@INSISCSDT-2370:~/guru_test/ltp$ make ARCH=riscv
guru@INSISCSDT-2370:~/guru_test/ltp$ sudo make ARCH=riscv install


