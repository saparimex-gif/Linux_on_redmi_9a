#!/bin/bash
set -euo pipefail

WORK_DIR="$(pwd)"
ROOTFS_DIR="$WORK_DIR/out_rootfs"

rm -rf "$ROOTFS_DIR" "$WORK_DIR/initramfs.cpio.gz"
mkdir -p "$ROOTFS_DIR"/{bin,sbin,etc,proc,sys,dev,tmp,mnt/root}

curl -fsSL "https://raw.githubusercontent.com/EXALAB/Busybox-static/main/busybox_arm64" -o "$ROOTFS_DIR/bin/busybox"
chmod +x "$ROOTFS_DIR/bin/busybox"

cp "$WORK_DIR/rootfs/init" "$ROOTFS_DIR/init"
chmod +x "$ROOTFS_DIR/init"

(
  cd "$ROOTFS_DIR"
  find . -print0 | cpio --null -ov --format=newc | gzip -9 > "$WORK_DIR/initramfs.cpio.gz"
)

echo "Initramfs siap: $(du -h "$WORK_DIR/initramfs.cpio.gz")"
