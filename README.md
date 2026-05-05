# Tailscale Secure Backup Lab

## Overview

This project demonstrates a secure, real-world backup architecture using Tailscale to connect multiple remote environments without requiring VPNs, port forwarding, or complex firewall configurations.

Each location maintains its own local backups while securely replicating data to a centralized off-site server for disaster recovery.

---

## Problem

Managing backups across multiple remote locations typically requires:

- VPN configuration
- Public IP addresses
- Firewall rules
- Complex networking

This project eliminates those requirements by using Tailscale as a private network layer.

---

## Solution

- Each site has a **local backup server**
- Clients back up locally (fast, reliable restores)
- Backup servers replicate data **securely over the Tailnet**
- A central **admin server** stores off-site copies

---

## Key Features

- 🔒 Secure private networking (Tailscale)
- 🚫 No port forwarding or firewall changes
- 💾 Local + off-site backup strategy
- 🔑 Tailscale SSH (no key management)
- 🧠 Simple, scalable architecture

---

## Architecture

See:
- `architecture/overview.md`
- `architecture/diagram.md`

---

## Setup Guide

Follow in order:

1. `setup/environment.md`
2. `setup/tailscale.md`
3. `setup/parents-backup.md`
4. `setup/inlaws-backup.md`

---

## Demo

See:
- `demo/demo-script.md`

---

## How It Works (Quick Summary)

1. Macs back up to their **local server**
2. Backup servers store data locally
3. Backup servers replicate data to **adminserver** using `rsync` over Tailscale
4. Adminserver acts as the **off-site backup destination**

---

## Technologies Used

- Tailscale
- Ubuntu Server
- Proxmox (lab environment)
- rsync
- cron

---

## Outcome

A secure, low-maintenance backup system that works across multiple locations without traditional networking complexity.
