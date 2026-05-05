#!/bin/bash

# ===== CONFIG =====
DEST="backupuser@ADMIN_SERVER:/backups/SITE/manual/"
SOURCE="/backup/manual/"
LOGFILE="/backup/logs/test-rsync.log"

# ===== RUN =====
echo "==== Test rsync started at $(date) ====" >> "$LOGFILE"

rsync -az --delete "$SOURCE" "$DEST" >> "$LOGFILE" 2>&1

echo "==== Test rsync finished at $(date) ====" >> "$LOGFILE"
