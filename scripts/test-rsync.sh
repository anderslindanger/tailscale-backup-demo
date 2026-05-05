#!/bin/bash
echo "test $(date)" > /backup/manual/test.txt
rsync -avz /backup/manual user@adminserver:/backups/
