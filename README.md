# Tailscale Secure Backup Demo

## Overview

This project demonstrates a secure multi-site backup architecture using Tailscale. It simulates multiple remote locations in Proxmox and uses Tailscale to provide secure connectivity, access control, and Time Machine backup access without exposing services to the public internet.

## Problem

Family members and small organizations often have poor backup practices. Devices may be spread across multiple locations, and traditional remote access often requires port forwarding, VPN complexity, or insecure exposure of services.

This project solves that by creating a private, access-controlled backup network.

## Solution

The design uses:

- Tailscale for secure mesh networking
- ACLs and tags for role-based access control
- Proxmox to simulate multiple physical locations
- Ubuntu Server as backup servers
- Samba for macOS Time Machine backups

## Architecture

| Location | Node | Purpose |
|---|---|---|
| Admin/Home | adminserver | Central admin and replication target |
| Parents | parents | Local Time Machine backup server |
| In-laws | inlaws | Local backup server for future expansion |
| Client | morgans-macbook-air | Parent client device |

## Access Model

- Admin can access and manage all nodes.
- Parent clients can only access the parents backup server.
- In-law clients can only access the in-laws backup server.
- Backup servers can replicate to the admin server.
- End users cannot SSH into infrastructure.

## Tailscale Features Demonstrated

- Device enrollment
- Tags
- Groups
- ACLs / grants
- Tailscale SSH
- MagicDNS
- Secure access to SMB/Time Machine over the tailnet

## Demo Validation

The demo validates:

1. Admin SSH access works.
2. Parent client backup access works.
3. Parent client cannot access unauthorized systems.
4. Time Machine can discover and use the backup share.
5. No public ports are required.

## Setup Documentation

Detailed setup steps are documented in the `/setup` folder.

## Real-World Use

This lab simulates separate locations using Proxmox bridges. In a real deployment, each VM would be replaced by a physical server or NAS located at a family member’s home or remote office.# tailscale-backup-demo
Secure multi-site backup architecture using Tailscale with Time Machine, ACLs, and Proxmox-based infrastructure
