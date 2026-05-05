#!/bin/bash

# ===== CONFIG =====
SITE="parents"   # change to "inlaws" when needed
DEST="backupuser@ADMIN_SERVER:/backups/${SITE}/manual/"
SOURCE="/backup/manual/"
LOGFILE="/backup/logs/test-rsync.log"

# ===== CREATE TEST FILE =====
mkdir -p "$SOURCE"
echo "test $(date)" > "${SOURCE}test.txt"

# ===== RUN TEST =====
echo "==== Test rsync started at $(date) ====" >> "$LOGFILE"

rsync -az --delete "$SOURCE" "$DEST" >> "$LOGFILE" 2>&1

echo "==== Test rsync finished at $(date) ====" >> "$LOGFILE"

# ===== VERIFY =====
echo "Test complete. Verify on adminserver:"
echo "cat /backups/${SITE}/manual/test.txt"
