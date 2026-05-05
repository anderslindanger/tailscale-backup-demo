# Proxmox Environment Setup

## Overview

This lab uses Proxmox VE to simulate a **multi-site backup architecture** within a single host.

Instead of relying on network-level isolation, this design uses Tailscale to enforce **secure, logical separation between environments**, while keeping all systems on a shared network for simplicity and internet access.

### Goals

- Simulate multiple remote locations
- Provide local backup capability at each site
- Enable secure off-site replication
- Demonstrate a real-world, reproducible architecture

---

## Network Design

All virtual machines are connected to a single Proxmox bridge:

| Bridge | Purpose |
|--------|--------|
| vmbr0  | Shared network with internet access |

Although all systems share the same underlying network, **they do not communicate over the LAN**.

### Key Design Principle

All inter-system communication occurs over the **Tailscale tailnet**.

- Uses Tailscale IPs or MagicDNS
- Traffic is encrypted end-to-end
- Access is controlled via ACLs and tags

This simulates separate physical locations without requiring VLANs or multiple bridges.

---

## Virtual Machines

| VM | Role | Function |
|----|------|----------|
| **adminserver** | Central Node | Receives replicated backups |
| **parents** | Backup Server | Local backups + replication |
| **inlaws** | Backup Server | Local backups + replication |

### Responsibilities

Each backup server:
1. Stores local backups for fast restore  
2. Replicates backup data to `adminserver` over Tailscale  

---

## Architecture Purpose

This lab demonstrates a **Tailscale-first architecture**.

### Logical Isolation

- Nodes communicate only over Tailscale
- No reliance on local subnet routing
- Fully portable to real-world deployments

### Local Backup (Primary)

- Devices back up to a local server
- Enables fast recovery

### Off-Site Replication (Secondary)

- Backup data is replicated to `adminserver`
- Protects against:
  - Hardware failure
  - Site loss

### Centralized Management

`adminserver` acts as:
- Backup aggregation point
- Recovery location
- Administrative control node

---

## Deployment Process

1. Create Proxmox VMs using `vmbr0`
2. Install Ubuntu Server on each VM
3. Apply system updates
4. Install required packages
5. Install and authenticate Tailscale on all nodes
6. Verify connectivity over the tailnet
7. Confirm all inter-node traffic uses Tailscale

---

## Result

The final environment successfully demonstrates:

- Multi-site backup architecture
- Secure communication via Tailscale
- Local + off-site backup strategy

### Key Advantages

- No VLAN or complex networking required
- Fully reproducible on a single host
- Scales easily to real-world environments

---

## Design Decision: Why Not VLANs or Multiple Bridges?

Traditional lab setups simulate multiple sites using VLANs or separate network bridges.

This project intentionally avoids that approach.

### Reasons

- Reduces complexity
- Keeps setup simple and reproducible
- Focuses on Tailscale as the networking layer

### Outcome

Tailscale becomes the **primary control plane**, providing:
- Secure connectivity
- Access control
- Cross-network communication

This mirrors how modern distributed environments are increasingly designed.

---
