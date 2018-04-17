#!/bin/bash -e

#Alacarte fixes
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/applications"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/desktop-directories"

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/dresden-elektronik"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/dresden-elektronik/deCONZ"

echo "Phoscon-GW, V4_00, $(date +%Y-%m-%d)" > "${ROOTFS_DIR}/home/pi/.local/share/dresden-elektronik/deCONZ/gw-version"

# enable deconz autostart
ln -s "${ROOTFS_DIR}/etc/systemd/system/deconz-gui.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz-gui.service"
ln -s "${ROOTFS_DIR}/etc/systemd/system/deconz-init.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz-init.service"

# enable vncserver autostart
ln -s "${ROOTFS_DIR}/usr/lib/systemd/system/vncserver-x11-serviced.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service"



