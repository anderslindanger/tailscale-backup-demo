# Architecture Overview

## Design Goals

- Secure communication between isolated environments
- No reliance on public IPs or VPN infrastructure
- Local backups for fast restores
- Off-site replication for disaster recovery
- Minimal configuration and maintenance

---

## Environment Layout

This lab simulates three separate locations:

- **adminserver**
  - Central backup aggregation point
  - Stores off-site copies of all backups

- **parents**
  - Local backup server for parents
  - Replicates data to adminserver

- **inlaws**
  - Local backup server for in-laws
  - Replicates data to adminserver

Each system operates independently and communicates only through Tailscale.

---

## Networking Model

- No direct LAN connectivity between sites
- All communication flows through the **Tailscale Tailnet**
- Devices are identified by hostname and tags
- MagicDNS is used for name resolution

---

## Data Flow

1. Client devices (Macs) perform backups to local servers
2. Local servers store backup data on attached disks
3. Backup servers push data to adminserver using `rsync`
4. Adminserver stores off-site copies for recovery

---

## Why This Design Works

- Eliminates need for VPNs and firewall rules
- Keeps backups local for performance
- Adds off-site redundancy for protection
- Uses encrypted peer-to-peer connections

---

## Key Principle

> Decentralized backups with centralized protection
