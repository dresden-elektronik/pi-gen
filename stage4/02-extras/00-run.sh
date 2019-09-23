#!/bin/bash -e

#Alacarte fixes
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share/applications"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share/desktop-directories"

# enable deconz-gui autostart


if [ -d "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants" ];then
    ls -l "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants" | grep deconz
else
   echo "[WARN] Directory ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants not found"
fi

#TODO: file ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz.service not found
#if [ -f "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz.service" ]; then
    unlink "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz.service"
#else
#    echo "[WARN] did not find file ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz.service"
#fi

if [ ! -f "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz-gui.service" ]; then
    ln -s "/lib/systemd/system/deconz-gui.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/deconz-gui.service"
fi

# enable vncserver autostart
if [ ! -f "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service" ]; then
    ln -s "/usr/lib/systemd/system/vncserver-x11-serviced.service" "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service"
fi
