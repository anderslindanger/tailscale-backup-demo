# Architecture Overview

## Overview

This project demonstrates a **secure, multi-site backup architecture** built using Tailscale.

It simulates three independent locations that:

* Provide **local backups for fast recovery**
* Replicate data **off-site for disaster protection**
* Communicate securely **without exposing any services to the internet**

---

## Design Goals

* Secure communication between isolated environments
* No reliance on public IPs, port forwarding, or traditional VPNs
* Fast local backups with off-site redundancy
* Identity-based access control using Tailscale ACLs
* Minimal operational overhead

---

## Environment Layout

This lab simulates three separate locations:

### Admin Location

* **adminserver**

  * Central backup aggregation point
  * Stores off-site copies from all locations
  * Acts as the administrative control node

---

### Parents Location

* **parents**

  * Local backup server for parents
  * Hosts Time Machine backups
  * Replicates backup data to `adminserver`

---

### In-laws Location

* **inlaws**

  * Local backup server for in-laws
  * Hosts Time Machine backups
  * Replicates backup data to `adminserver`

---

### Key Characteristic

Each location operates independently and does **not rely on local network connectivity** to communicate.

All communication is handled through the Tailscale tailnet.

---

## Networking Model

This architecture intentionally avoids traditional networking complexity.

* No VLANs
* No site-to-site VPNs
* No firewall rules or port forwarding

Instead:

* All devices join a shared **Tailscale tailnet**
* Communication occurs over encrypted peer-to-peer connections
* Devices are identified by:

  * Hostname
  * Tags (device role)
  * User identity

### Identity-Based Access

Access is controlled using:

* **Tags** → define device roles
* **Groups** → define user access
* **ACLs** → define allowed communication

This ensures that:

* Devices can only access what they are explicitly allowed to
* Network location is irrelevant

---

## Data Flow

```text
Mac → Local Backup Server → Admin Server
```

1. Client devices (MacBooks) perform backups to their local server using SMB (Time Machine)
2. Local servers store backup data in `/backup/...`
3. Backup servers replicate data to `adminserver` using `rsync` over Tailscale
4. `adminserver` stores off-site copies in `/backups/...`

---

## Why This Design Works

This architecture combines simplicity with strong security guarantees.

### Simplicity

* No network configuration required
* No port forwarding or NAT traversal setup
* Works the same across any environment

---

### Security

* No publicly exposed services
* End-to-end encrypted communication
* Least-privilege access enforced via ACLs
* Identity-based authentication instead of network-based trust

---

### Reliability

* Local backups allow fast recovery
* Off-site replication protects against data loss
* Independent sites reduce single points of failure

---

## Key Principle

> **Decentralized backups with centralized protection**

Each location maintains its own backup capability, while a central system ensures long-term durability and disaster recovery.

---

## Real-World Relevance

This design can be directly applied to:

* Home lab environments
* Small businesses with multiple locations
* Remote teams and distributed infrastructure
* Backup solutions for non-technical users

No architectural changes are required when moving from this lab to a real-world deployment.
