#!/bin/bash

# Creates a test file and replicates it to adminserver using rsync over Tailscale.
# Update ADMIN_SERVER and SITE before running.

set -e

# ===== CONFIG =====
SITE="parents"              # change to "inlaws" when needed
ADMIN_SERVER="adminserver"  # change if using Tailscale IP or different hostname

DEST="backupuser@${ADMIN_SERVER}:/backups/${SITE}/manual/"
SOURCE="/backup/manual/"
LOGFILE="/backup/logs/test-rsync.log"

# ===== PREP =====
mkdir -p "$SOURCE"
mkdir -p /backup/logs

# ===== CREATE TEST FILE =====
echo "test backup $(date)" > "${SOURCE}test.txt"

# ===== RUN TEST =====
echo "==== Test rsync started at $(date) ====" >> "$LOGFILE"

rsync -az --delete "$SOURCE" "$DEST" >> "$LOGFILE" 2>&1

echo "==== Test rsync finished at $(date) ====" >> "$LOGFILE"

# ===== VERIFY =====
echo
echo "Test complete."
echo "Verify on adminserver:"
echo "cat /backups/${SITE}/manual/test.txt"
