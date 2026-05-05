# Proxmox Environment Setup

## Overview

This lab uses Proxmox VE to simulate a **multi-site backup environment** on a single host.

Each virtual machine represents a separate physical location (Admin, Parents, In-laws).
Although all systems run on the same underlying network, **they are treated as independent sites**.

All inter-system communication is handled through Tailscale, not the local network.

---

## Goals

* Simulate multiple remote sites within a single Proxmox host
* Provide local backup servers per site
* Prepare systems for secure communication via Tailscale
* Keep the environment simple, reproducible, and realistic

---

## Host Requirements

* Proxmox VE installed
* Internet access
* Minimum **1 TB of available storage** (required for backup simulation)

### Recommended Resources

* CPU: 4+ cores
* RAM: 8–16 GB

---

## Virtual Machine Specifications

Create the following virtual machines:

| VM Name     | Role          | Disk    | Description                                  |
| ----------- | ------------- | ------- | -------------------------------------------- |
| adminserver | Central Node  | 200 GB  | Receives off-site replicated backups         |
| parents     | Backup Server | 500 GB+ | Stores local backups and replicates off-site |
| inlaws      | Backup Server | 100 GB+ | Stores local backups and replicates off-site |

> Storage sizing is intentional to simulate real-world backup constraints and behavior.

---

## Network Configuration

All VMs are connected to:

| Bridge | Purpose                                     |
| ------ | ------------------------------------------- |
| vmbr0  | Default network with DHCP + internet access |

### Key Notes

* IP addresses are assigned via **local DHCP**
* No static IP configuration is required
* No VLANs or network isolation are used

Although the machines share a network, this does **not affect the lab outcome**.

All meaningful communication occurs over the Tailscale tailnet, making this setup functionally identical to geographically distributed systems.

---

## VM Setup Steps

Repeat the following steps for each VM:

### 1. Create Virtual Machine

* OS: Ubuntu Server (22.04 LTS or newer)
* CPU: 1–2 cores
* RAM: 2–4 GB
* Disk: Based on table above

### 2. Install Ubuntu Server

During installation:

* Enable **OpenSSH Server**
* Use DHCP (default network settings)
* Set a hostname matching the VM name:

  * `adminserver`
  * `parents`
  * `inlaws`

### 3. Update System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## Validation

Before continuing, verify:

* All VMs have internet access
* SSH access works from your host machine
* Each VM is reachable via its assigned DHCP IP

Example:

```bash
ssh user@<vm-ip>
```

---

## Design Principle

This lab intentionally avoids traditional network complexity.

* No VLANs
* No firewall rules
* No port forwarding

Instead, networking is abstracted entirely through Tailscale.

This ensures:

* Consistent behavior regardless of physical location
* Secure, encrypted communication between all nodes
* A clean and reproducible lab environment

---

## Next Step

Continue to:

➡️ `02-tailscale.md`

This is where secure connectivity, access control, and node identity are configured.
