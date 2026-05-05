#!/bin/bash

# Creates a test file and replicates it to the adminserver using rsync over Tailscale.
# Update ADMIN_SERVER and SITE before running.

set -e

# ===== CONFIG =====
ADMIN_SERVER="adminserver"   # Change if needed
SITE="parents"               # Change to "inlaws" when testing that server

SOURCE="/backup/manual/"
DEST="backupuser@${ADMIN_SERVER}:/backups/${SITE}/manual/"
LOGFILE="/backup/logs/test-rsync.log"

# ===== PREP =====
mkdir -p "$SOURCE"
mkdir -p /backup/logs

# ===== CREATE TEST FILE =====
echo "test backup $(date)" > "${SOURCE}test.txt"

# ===== RUN =====
echo "==== Test rsync started at $(date) ====" >> "$LOGFILE"

rsync -az --delete "$SOURCE" "$DEST" >> "$LOGFILE" 2>&1

echo "==== Test rsync finished at $(date) ====" >> "$LOGFILE"

# ===== OUTPUT =====
echo "Test complete."
echo "Verify on adminserver:"
echo "cat /backups/${SITE}/manual/test.txt"
