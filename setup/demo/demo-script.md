# Demo Script

## Overview

This demo shows how Tailscale can be used to build a secure, multi-site backup solution without exposing services to the public internet.

The environment simulates three locations:

- Admin location
- Parents location
- In-laws location

## Step 1 — Introduce the Problem

Explain:

- Backups across multiple locations are difficult
- Traditional solutions require:
  - Port forwarding
  - VPN complexity
  - Security risks

**Goal:**
Create a secure, simple, and scalable backup system.

---

## Step 2 — Show Architecture

Explain:

- Each location has its own network
- Systems are isolated (Proxmox bridges)
- Tailscale connects everything securely

Nodes:

- adminserver → central control
- parents → local backup server
- inlaws → additional backup server
- client devices → laptops

---

## Step 3 — Show Tailscale Network

Show:

```bash
tailscale status
