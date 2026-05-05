# Proxmox Environment Setup

## Overview

This project uses Proxmox to simulate multiple physical locations in a controlled lab environment.

## Network Design

The following Proxmox bridges were used:

| Bridge | Purpose |
|---|---|
| vmbr0 | Admin/Home network |
| vmbr1 | Parents network |
| vmbr2 | In-laws network |

## Virtual Machines

| VM | Purpose |
|---|---|
| adminserver | Central admin and replication target |
| parents | Parents local backup server |
| inlaws | In-laws local backup server |

## Process

1. Created isolated Linux bridges in Proxmox.
2. Created Ubuntu Server VMs.
3. Used vmbr0 temporarily for internet access during setup.
4. Installed updates and required packages.
5. Moved VMs to their intended simulated networks.
6. Used Tailscale to securely connect the environments.

## Result

The lab simulates separate locations while remaining easy to reproduce on a single Proxmox host.
