#/bin/bash

cd _install/
find . | cpio -o --format=newc > ../rootfs.img
cd ..
gzip -c rootfs.img > rootfs.img.gz

echo "rootfs.img.gz - image created"
ls -lh rootfs.img.gz


