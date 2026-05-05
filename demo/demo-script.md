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

Explain:

All nodes are connected
No public IPs or port forwarding
Communication happens over the tailnet
Step 4 — Explain Access Control

Explain:

Access is controlled using:
Tags
Groups
ACLs

Key idea:

Not all devices can talk to each other
Access is limited based on role
Step 5 — Demonstrate Admin Access

From admin device:

ssh alindanger@parents

Explain:

Admin has full access
Managed through Tailscale SSH
No firewall rules needed
Step 6 — Demonstrate Restricted Access

From parent user (or explain):

Attempt SSH to backup server → Denied
Attempt access to other nodes → Denied

Explain:

End users cannot access infrastructure
Only required services are exposed
Step 7 — Demonstrate Backup Access

From Mac:

Connect to:
smb://parents

Show:

Time Machine disk appears
Backup starts successfully

Explain:

Backup happens over Tailscale
No public exposure
Fully encrypted
Step 8 — Highlight Security

Explain:

No open ports
Identity-based access
Least privilege model
Encrypted traffic
Step 9 — Real-World Application

Explain:

Replace VMs with:
Home servers
NAS devices
Remote offices
Same design works without changes
Step 10 — Close

Summary:

Secure
Simple
Scalable
Real-world applicable

Final statement:

“This demonstrates how Tailscale can securely connect distributed environments while enforcing strict access control and enabling practical services like backups.”
