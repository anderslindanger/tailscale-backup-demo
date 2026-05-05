# Tailscale Secure Backup Lab

## Overview

This project demonstrates a **secure, multi-site backup architecture** built using Tailscale.

It connects multiple remote environments into a single private network **without requiring VPNs, port forwarding, or complex firewall configurations**.

Each location maintains its own local backups while securely replicating data to a centralized off-site server for disaster recovery.

---

## The Problem

Managing backups across multiple locations is typically complex and fragile.

Traditional approaches require:

* VPN configuration
* Public IP addresses
* Port forwarding
* Firewall rules
* SSH key management

This introduces:

* Security risks
* Operational overhead
* Difficult troubleshooting

---

## The Solution

This project replaces traditional networking with **identity-based connectivity**.

* Each site has a **local backup server**
* Clients back up locally for fast recovery
* Backup servers replicate data securely over the **Tailscale tailnet**
* A central **admin server** stores off-site copies

No services are exposed to the public internet.

---

## Key Features

* 🔒 Secure private networking using Tailscale
* 🚫 No port forwarding or firewall changes
* 💾 Local + off-site backup strategy
* 🔑 Tailscale SSH (no SSH key management required)
* 🧠 Simple, scalable, and reproducible design

---

## Architecture

* `architecture/overview.md`
* `architecture/diagram.md`

This architecture demonstrates:

* Decentralized backups with centralized protection
* Identity-based access control using tags and ACLs
* Secure communication across isolated environments

---

## Setup Guide

Follow the setup in order:

1. `setup/01-environment.md`
2. `setup/02-tailscale.md`
3. `setup/03-acls.md`
4. `setup/04-parents-backup-and-replication.md`
5. `setup/05-inlaws-backup-and-replication.md`

Each step builds toward a fully working multi-site backup system.

---

## Demo

* `demo/06-demo-script.md`

This demonstrates:

* Secure connectivity between nodes
* Identity-based access control
* Real backup + replication workflow

---

## How It Works

```text id="3m9u4q"
Mac → Local Backup Server → Admin Server
```

1. Macs back up to their **local server** using Time Machine (SMB)
2. Backup servers store data locally in `/backup/...`
3. Backup servers replicate data to `adminserver` using `rsync` over Tailscale
4. `adminserver` stores off-site copies in `/backups/...`

---

## Technologies Used

* Tailscale
* Ubuntu Server
* Proxmox (lab environment)
* rsync
* cron
* Samba (Time Machine support)

---

## Outcome

This project delivers a **secure, low-maintenance, and production-ready backup architecture** that:

* Works across multiple locations
* Requires no traditional network configuration
* Enforces least-privilege access
* Scales easily to real-world environments

---

## Key Takeaway

> **Secure networking doesn’t need to be complex.**
> With Tailscale, identity replaces infrastructure.
