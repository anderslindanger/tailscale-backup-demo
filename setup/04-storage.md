# Storage Setup

## Overview

Each backup server uses a dedicated storage volume for backups.  
This ensures that backup data is separated from the operating system and can be managed independently.

In this lab environment, a virtual disk is attached to the `parents` server to simulate a local backup drive.

## Disk Configuration in Proxmox

A secondary virtual disk was added to the `parents` VM:

- Primary disk (`sda`) → Operating system
- Secondary disk (`sdb`) → Backup storage (~550GB)

## Identify the Disk

After attaching the disk, it was identified using:

```bash
lsblk

Example output:

sda   100G   (OS)
sdb   550G   (Backup disk)
Format the Disk

The backup disk was formatted using ext4:

sudo mkfs.ext4 /dev/sdb
Create Mount Point
sudo mkdir -p /mnt/backups
Mount the Disk
sudo mount /dev/sdb /mnt/backups

Verify:

df -h

Expected output includes:

/dev/sdb   ~550G   ...   /mnt/backups
Persist Mount (Important)

To ensure the disk mounts automatically after reboot:

Get the UUID:
sudo blkid
Add to /etc/fstab:
UUID=b067558f-6d24-4cd2-a7f8-98e06a2db89d /mnt/backups ext4 defaults 0 2
Test:
sudo mount -a
Permissions

The backup directory is owned by the backup user:

sudo chown -R alindanger:alindanger /mnt/backups
sudo chmod -R 700 /mnt/backups
Design Considerations
Backup storage is isolated from the OS
Storage can be expanded independently
Same design can be used with:
External drives
NAS systems
Cloud-backed volumes
Result

The parents server now has a dedicated, persistent storage volume ready for Time Machine backups.
