## Step 1 – Install Required Packages

```bash
sudo apt update
sudo apt install -y tailscale samba rsync
 
Step 2 – Install and Connect Tailscale
sudo tailscale up
•	Authenticate in browser 
•	Verify connection: 
tailscale status
 
Step 3 – Apply Tags (IMPORTANT)
In Tailscale Admin Console:
Assign:
tag:inlaws-backup
tag:inlaws-client
 
Step 4 – Create Backup Directory Structure
sudo mkdir -p /backup/{timemachine,manual,logs}
sudo chown -R $USER:$USER /backup
 
Step 5 – Configure Samba (Time Machine)
Edit Samba config:
sudo nano /etc/samba/smb.conf
Add at bottom:
[TimeMachine]
path = /backup/timemachine
browseable = yes
read only = no
guest ok = no
valid users = backupuser
fruit:time machine = yes
fruit:time machine max size = 200G
vfs objects = catia fruit streams_xattr
 
Step 6 – Create Samba User
sudo adduser backupuser
sudo smbpasswd -a backupuser

New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for backupuser
Enter the new value, or press ENTER for the default
	Full Name []: andersl
	Room Number []: 3
	Work Phone []: 44
	Home Phone []: 
	Other []: 
Is the information correct? [Y/n] y
 
Step 7 – Restart Samba
sudo systemctl restart smbd
 
Step 8 – Test SMB Share (from Mac)
sudo smbpasswd -a backupuser

sudo systemctl restart smbd

On Mac:
1.	Open Finder 
2.	Go to:
smb://100.x.x.x


3.	Login with: 
o	Username: backupuser 
o	Password: (set above) 
o	If Wrong do commands above--
4.	Enable Time Machine: 
o	Select the share 
o	Start backup (For the first backup you need to leave your computer on. The next ones will go faster) estimate 1h
 
Step 9 – Configure SSH Access
--Get the public key from parents
On parents server, run:
cat ~/.ssh/id_ed25519.pub
You will see ONE long line like:
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... alindanger@parents
👉 Copy the entire line exactly
  — Go to inlaws server
SSH into inlaws:
ssh alindanger@100.107.185.66
 
— Create the .ssh folder
Run:
sudo mkdir -p /home/backupuser/.ssh
 
— Open authorized_keys file
sudo nano /home/backupuser/.ssh/authorized_keys
Now:
👉 Paste the ENTIRE key you copied
It should look like this (ONE LINE):
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... alindanger@parents
⚠️ IMPORTANT:
•	No line breaks 
•	No extra spaces 
•	One line only 
 
— Save and exit nano
•	Press CTRL + O → Enter 
•	Press CTRL + X 
 
— Fix permissions (CRITICAL)
Run exactly:
sudo chown -R backupuser:backupuser /home/backupuser/.ssh
sudo chmod 700 /home/backupuser/.ssh
sudo chmod 600 /home/backupuser/.ssh/authorized_keys
 
— Verify it looks correct
Run:
sudo ls -ld /home/backupuser/.ssh
sudo ls -l /home/backupuser/.ssh
sudo cat /home/backupuser/.ssh/authorized_keys
You should see:
drwx------  backupuser backupuser .ssh
-rw-------  backupuser backupuser authorized_keys
 
— Test SSH from inlaws
Go back to inlaws server and run:
ssh backupuser@100.89.18.91
 
++++++++++++++++++++++++++ 
Step 10 – Create rsync Backup Script
nano ~/backup.sh
Paste:
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











Do not leave ADMIN_TAILSCALE_IP in the script.!
 
Step 11 – Make Script Executable
chmod +x ~/backup.sh
 
Step 12 – Test Backup
Before configuring real backups (e.g., Time Machine), verify that off-site replication works correctly using a test file.
### 1. Create Test Data
```bash
mkdir -p /backup/manual
echo "test backup $(date)" > /backup/manual/test.txt


RUN the script:
./backup.sh



Verify on adminserver:
cat /backups/inlaws/manual/test.txt




Troubleshooting
If the file does not appear:
•	Check logs:
cat /backup/logs/backup.log
•	Verify SSH access:
ssh backupuser@100.89.18.91
•	Ensure the script uses the correct Tailscale IP (not a placeholder)



 
Step 13 – Schedule Cron Job
crontab -e



Select 1.
FILL in your SSH Username before:
Add:

0 3 * * * /home/YOUR_USER/backup.sh


SAVE IT
 
Step 14 – Final Verification
Check:
tailscale status
ssh backupuser@ADMIN_TAILSCALE_IP
cat /backup/logs/backup.log
On adminserver:
ls -lah /backups/inlaws/
 
Security Model
•	Only in-laws devices can access this server via ACLs 
•	Only backupuser is allowed SSH access 
•	No ports exposed to the internet 
•	All traffic runs through Tailscale 

