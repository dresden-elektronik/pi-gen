#!/bin/bash -e

install -m 755 files/resize2fs_once	"${ROOTFS_DIR}/etc/init.d/"

install -d				"${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d"
install -m 644 files/ttyoutput.conf	"${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d/"

install -m 644 files/50raspi		"${ROOTFS_DIR}/etc/apt/apt.conf.d/"

install -m 644 files/console-setup   	"${ROOTFS_DIR}/etc/default/"

install -m 755 files/rc.local		"${ROOTFS_DIR}/etc/"

on_chroot << EOF
systemctl disable hwclock.sh
systemctl disable nfs-common
systemctl disable rpcbind
if [ "${ENABLE_SSH}" == "1" ]; then
	systemctl enable ssh
else
	systemctl disable ssh
fi
systemctl enable regenerate_ssh_host_keys
EOF

if [ "${USE_QEMU}" = "1" ]; then
	echo "enter QEMU mode"
	install -m 644 files/90-qemu.rules "${ROOTFS_DIR}/etc/udev/rules.d/"
	on_chroot << EOF
systemctl disable resize2fs_once
EOF
	echo "leaving QEMU mode"
else
	on_chroot << EOF
systemctl enable resize2fs_once
EOF
fi

on_chroot <<EOF
for GRP in input spi i2c gpio; do
	groupadd -f -r "\$GRP"
done
for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c netdev; do
  adduser $FIRST_USER_NAME \$GRP
done
EOF

on_chroot << EOF
setupcon --force --save-only -v
EOF

on_chroot << EOF
usermod --pass='*' root
EOF

on_chroot << EOF
# remove proxy if not needed
https_proxy="http://192.168.10.1:8080" wget https://project-downloads.drogon.net/wiringpi-latest.deb
dpkg -i wiringpi-latest.deb
EOF

# set up rtc
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/rtc-source"
install -m 644 files/Makefile "${ROOTFS_DIR}/home/pi/rtc-source/"
install -m 644 files/rtc-pcf85063.service "${ROOTFS_DIR}/home/pi/rtc-source/"
on_chroot << EOF
cd "/home/pi/rtc-source/"
echo "available kernels:"
ls -l "/lib/modules"
make
make install
EOF


rm -f "${ROOTFS_DIR}/etc/ssh/"ssh_host_*_key*

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/dresden-elektronik"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/dresden-elektronik/deCONZ"
install -m 644 files/config.ini "${ROOTFS_DIR}/home/pi/.local/share/dresden-elektronik/deCONZ/"

echo "Phoscon-GW, V4_00, $(date +%Y-%m-%d)" > "${ROOTFS_DIR}/home/pi/.local/share/dresden-elektronik/deCONZ/gw-version"

# enable deconz autostart
ln -s "/lib/systemd/system/deconz.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz.service"
ln -s "/lib/systemd/system/deconz-init.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz-init.service"
