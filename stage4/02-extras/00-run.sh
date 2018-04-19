#!/bin/bash -e

#Alacarte fixes
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/applications"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/desktop-directories"

# enable deconz-gui autostart
unlink "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz.service"
ln -s "/etc/systemd/system/deconz-gui.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz-gui.service"

# enable vncserver autostart
ln -s "/usr/lib/systemd/system/vncserver-x11-serviced.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service"
