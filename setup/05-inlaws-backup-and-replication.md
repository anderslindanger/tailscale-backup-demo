# In-laws Backup & Replication Setup

## Overview

This document configures the **in-laws backup server** to:

1. Provide local Time Machine backups via SMB
2. Store manual backups
3. Replicate all backup data to the `adminserver` over the Tailscale network

This setup mirrors the parents environment, but remains **fully isolated**.

---

## Architecture Flow

```text id="z2rj1w"
MacBook → inlaws → adminserver
```

* Local backups stay on `inlaws`
* Off-site copies are stored on `adminserver`
* No communication exists between `parents` and `inlaws`

---

# Step 1 – Install Required Packages

SSH into the in-laws server:

```bash id="8a9v3x"
ssh alindanger@inlaws
```

Install required packages:

```bash id="p1xtyb"
sudo apt update
sudo apt install -y samba rsync
```

---

# Step 2 – Create Backup Directory Structure

```bash id="zjz5oq"
sudo mkdir -p /backup/{timemachine,manual,logs}
sudo chown -R $USER:$USER /backup
```

---

# Step 3 – Configure Samba (Time Machine)

Edit Samba config:

```bash id="r9myjv"
sudo nano /etc/samba/smb.conf
```

Add to the bottom:

```ini id="k0y9zx"
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

```bash id="gk0ptb"
sudo adduser backupuser
sudo smbpasswd -a backupuser
```

---

# Step 5 – Restart Samba

```bash id="7lb6p4"
sudo systemctl restart smbd
```

---

# Step 6 – Test SMB Share (from Mac)

On macOS:

1. Open Finder
2. Press `Cmd + K`
3. Connect to:

```text id="mq9m6r"
smb://<INLAWS_TAILSCALE_IP>
```

4. Login:

   * Username: `backupuser`
   * Password: (created above)

5. Enable Time Machine:

   * Select the share
   * Start backup

---

## Time Machine Behavior (Important)

The first Time Machine backup is a **full backup** and may take several hours.

* The Mac must remain powered on and connected
* Future backups are incremental and much faster

---

# Step 7 – Prepare Admin Server for In-laws Backups

SSH into adminserver:

```bash id="h7g1ra"
ssh alindanger@adminserver
```

Create destination folders:

```bash id="w1jjlm"
sudo mkdir -p /backups/inlaws/{manual,timemachine}
sudo chown -R backupuser:backupuser /backups
```

---

# Step 8 – Configure SSH Access to Admin Server

Unlike the parents setup, we **do NOT generate a new SSH key here**.

The `backupuser` account on this server will use SSH access already allowed by the Tailscale ACL policy.

---

## Test SSH Access

From the in-laws server:

```bash id="0g7y7p"
sudo -u backupuser ssh backupuser@adminserver
```

Expected:

```text id="b2x5ha"
Login successful (no password prompt or allowed via ACL)
```

If prompted for a password or denied:

* Verify ACL rules
* Verify Tailscale SSH is enabled
* Confirm correct tags are applied

---

# Step 9 – Create rsync Backup Script

```bash id="i7b6p1"
nano ~/backup.sh
```

Paste:

```bash id="u9w7qk"
#!/bin/bash

LOGFILE="/backup/logs/backup.log"

echo "==== Backup started at $(date) ====" >> "$LOGFILE"

rsync -az --delete \
  /backup/manual/ \
  backupuser@ADMIN_TAILSCALE_IP:/backups/inlaws/manual/ >> "$LOGFILE" 2>&1

rsync -az --delete \
  /backup/timemachine/ \
  backupuser@ADMIN_TAILSCALE_IP:/backups/inlaws/timemachine/ >> "$LOGFILE" 2>&1

echo "==== Backup finished at $(date) ====" >> "$LOGFILE"
```

⚠️ Replace:

```text id="g6jv7o"
ADMIN_TAILSCALE_IP
```

With the Tailscale IP of `adminserver`.

---

# Step 10 – Make Script Executable

```bash id="k4kcvz"
chmod +x ~/backup.sh
```

---

# Step 11 – Test Backup

Create test file:

```bash id="q0d1yo"
echo "test backup $(date)" > /backup/manual/test.txt
```

Run script:

```bash id="b5t5um"
./backup.sh
```

---

## Verify on Admin Server

```bash id="vwn3ju"
cat /backups/inlaws/manual/test.txt
```

---

## Troubleshooting

Check logs:

```bash id="3rbb2v"
cat /backup/logs/backup.log
```

Verify SSH:

```bash id="fjv1qz"
ssh backupuser@adminserver
```

---

# Step 12 – Schedule Cron Job

```bash id="0slx5g"
crontab -e
```

Select option `1`

Add:

```bash id="m1sjcz"
0 3 * * * /home/alindanger/backup.sh
```

---

# Step 13 – Final Verification

On in-laws server:

```bash id="xpxq9m"
tailscale status
ssh backupuser@adminserver
cat /backup/logs/backup.log
```

On adminserver:

```bash id="89hzj3"
ls -lah /backups/inlaws/
```

---

# Security Model

* In-laws devices can only access the in-laws backup server
* Backup replication is limited to `adminserver`
* No connectivity exists between parents and in-laws environments
* SSH access is controlled via Tailscale ACLs
* No services are exposed to the public internet
* All traffic flows through Tailscale

---

# Result

* Local Time Machine backups function correctly
* Backup data is replicated off-site
* Environments are isolated and secure
* System is fully reproducible

---

# Notes

* Logs are stored locally in `/backup/logs`
* `rsync --delete` ensures destination mirrors source
* Time Machine data is stored in `/backup/timemachine`

---

# Next Step

➡️ `06-demo-script.md`
