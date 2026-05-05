# Parents Backup & Replication Setup

## Overview

This document configures the **parents backup server** to:

1. Provide local Time Machine backups via SMB
2. Store manual backups
3. Replicate all backup data to the `adminserver` over the Tailscale network

This step also includes configuration required on the `adminserver` to receive backups.

---

## Architecture Flow

```text
MacBook → parents → adminserver
```

* Local backups stay on `parents`
* Off-site copies are stored on `adminserver`

---

# Step 1 – Install Required Packages

SSH into the parents server:

```bash
ssh alindanger@parents
```

Install required packages:

```bash
sudo apt update
sudo apt install -y samba rsync
```

---

# Step 2 – Create Backup Directory Structure

```bash
sudo mkdir -p /backup/{timemachine,manual,logs}
sudo chown -R $USER:$USER /backup
```

---

# Step 3 – Configure Samba (Time Machine)

Edit Samba config:

```bash
sudo nano /etc/samba/smb.conf
```

Add to the bottom:

```ini
[TimeMachine]
path = /backup/timemachine
browseable = yes
read only = no
guest ok = no
valid users = backupuser

vfs objects = catia fruit streams_xattr
fruit:time machine = yes
fruit:time machine max size = 200G
```

---

# Step 4 – Create Backup User

```bash
sudo adduser backupuser
sudo smbpasswd -a backupuser
```

---

# Step 5 – Restart Samba

```bash
sudo systemctl restart smbd
```

---

# Step 6 – Test SMB Share (from Mac)

On macOS:

1. Open Finder
2. Press `Cmd + K`
3. Connect to:

```text
smb://<PARENTS_TAILSCALE_IP>
```

4. Login:

   * Username: `backupuser`
   * Password: (created above)

5. Enable Time Machine:

   * Select the share
   * Start backup

---

## Time Machine Behavior (Important)

The first Time Machine backup is a **full backup**, which can take a significant amount of time depending on the size of the Mac.

### What to Expect

* The initial backup may take **hours**
* The Mac must remain:

  * Powered on
  * Connected to the network
* Backup speed depends on:

  * Network performance
  * Disk speed on the backup server

### After the First Backup

Once the initial backup is complete:

* Future backups are **incremental**
* Only changed files are transferred
* Backup times become significantly faster

### Recommendation

For the first backup:

* Keep the Mac plugged into power
* Disable sleep temporarily if needed
* Allow the backup to fully complete before testing restore or replication

This behavior is normal and expected when using Time Machine over SMB.

---

# Step 7 – Prepare Admin Server for Replication

SSH into adminserver:

```bash
ssh alindanger@adminserver
```

Create destination folders:

```bash
sudo mkdir -p /backups/parents/{manual,timemachine}
sudo chown -R backupuser:backupuser /backups
```

---

# Step 8 – Generate SSH Key (on Parents Server)

On the **parents server**, generate a key for `backupuser`:

```bash
sudo -u backupuser ssh-keygen -t ed25519
```

Press Enter for all prompts (no passphrase).

---

# Step 9 – Copy SSH Key to Admin Server

From the **parents server**, run:

```bash
sudo -u backupuser ssh-copy-id backupuser@adminserver
```

If prompted, enter the `backupuser` password on the admin server.

---

# Step 10 – Test SSH Access

Still on parents server:

```bash
sudo -u backupuser ssh backupuser@adminserver
```

Expected:

```text
Login successful without password prompt
```

---

# Step 11 – Create rsync Backup Script

Create script:

```bash
nano ~/backup.sh
```

Paste:

```bash
#!/bin/bash

LOGFILE="/backup/logs/backup.log"

echo "==== Backup started at $(date) ====" >> "$LOGFILE"

rsync -az --delete \
  /backup/manual/ \
  backupuser@ADMIN_TAILSCALE_IP:/backups/parents/manual/ >> "$LOGFILE" 2>&1

rsync -az --delete \
  /backup/timemachine/ \
  backupuser@ADMIN_TAILSCALE_IP:/backups/parents/timemachine/ >> "$LOGFILE" 2>&1

echo "==== Backup finished at $(date) ====" >> "$LOGFILE"
```

⚠️ Replace:

```text
ADMIN_TAILSCALE_IP
```

With the actual Tailscale IP of `adminserver`.

---

# Step 12 – Make Script Executable

```bash
chmod +x ~/backup.sh
```

---

# Step 13 – Test Backup

Create test file:

```bash
echo "test backup $(date)" > /backup/manual/test.txt
```

Run script:

```bash
./backup.sh
```

---

## Verify on Admin Server

```bash
cat /backups/parents/manual/test.txt
```

---

## Troubleshooting

Check logs:

```bash
cat /backup/logs/backup.log
```

Verify SSH:

```bash
ssh backupuser@adminserver
```

---

# Step 14 – Schedule Cron Job

```bash
crontab -e
```

Select option `1`

Add:

```bash
0 3 * * * /home/alindanger/backup.sh
```

---

# Step 15 – Final Verification

On parents:

```bash
tailscale status
ssh backupuser@adminserver
cat /backup/logs/backup.log
```

On adminserver:

```bash
ls -lah /backups/parents/
```

---

# Security Model

* Only parents devices can access this server (via ACLs)
* Only `backupuser` is used for replication
* SSH access is controlled by Tailscale
* No ports exposed publicly
* All traffic runs through Tailscale

---

# Result

* Time Machine backups work locally
* Backup data is replicated off-site
* System is secure, isolated, and reproducible

---

# Next Step

➡️ `05-inlaws-backup-and-replication.md`
