
---

# 📁 `setup/environment.md`

```md
# Environment Setup

## Overview

This lab uses Proxmox to simulate multiple remote environments.

Each virtual machine represents a separate physical location.

---

## Virtual Machines

The following VMs were created:

- `adminserver`
- `parents`
- `inlaws`

Each VM runs Ubuntu Server.

---

## Key Notes

- No VLANs or network bridges were used
- No direct networking between VMs
- All communication is handled by Tailscale

---

## Storage Setup

Each VM has local storage attached.

### Parents / In-laws

```bash
/backup/manual
