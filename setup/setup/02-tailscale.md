# Tailscale Setup

## Overview

Tailscale is used to connect the simulated remote locations without requiring port forwarding, public IP addresses, or traditional VPN firewall rules.

In this lab, Proxmox is used to simulate separate physical networks. Tailscale provides the secure private network layer that allows the systems to communicate even though the underlying networks are isolated.

## Goals

The Tailscale setup is designed to demonstrate:

- Secure connectivity between isolated environments
- Device identity using Tailscale nodes
- Role-based access using tags
- Admin access using Tailscale SSH
- Service access over the tailnet, specifically SMB for Time Machine backups
- No public exposure of backup services

## Nodes

The following nodes were enrolled into the tailnet:

| Node | Role | Tag |
|---|---|---|
| adminserver | Central admin and replication target | tag:admin |
| parents | Parents local backup server | tag:parents-backup |
| inlaws | In-laws local backup server | tag:inlaws-backup |
| morgans-macbook-air | Parent client device | tag:parents-client |
| anderss-macbook-pro | Admin client device | tag:admin |

## Install Tailscale

Run the following command on each Ubuntu Server node:

```bash
curl -fsSL https://tailscale.com/install.sh | sh



Bring Each Node Online

After installation, start Tailscale and authenticate the node:

sudo tailscale up --ssh

The --ssh option enables Tailscale SSH, which allows SSH access to be controlled by Tailscale ACLs instead of relying only on traditional network-based SSH access.

Authentication

Each node was authenticated into the tailnet using the admin account.

For a more reproducible deployment, an auth key could also be used:

sudo tailscale up --auth-key tskey-auth-REPLACE-ME --hostname parents --ssh

For this demo, interactive login was used first so that the setup could be validated manually before adding automation.

Node Naming

Nodes were renamed in the Tailscale admin console for clarity:

adminserver
parents
inlaws
morgans-macbook-air
anderss-macbook-pro

Clear naming is important because the demo uses these names when explaining the architecture and validating access.

Tags

The following tags were applied:

Tag	Purpose
tag:admin	Admin systems and admin client devices
tag:parents-backup	Parents local backup server
tag:inlaws-backup	In-laws local backup server
tag:parents-client	Parent client devices
tag:inlaws-client	In-law client devices
Why Tags Are Used

Tags allow access to be based on device role instead of individual IP addresses.

This makes the design easier to scale. For example:

Additional parent laptops can be tagged as tag:parents-client
Additional parent backup servers can be tagged as tag:parents-backup
Admin systems can be tagged as tag:admin

The ACL policy can remain mostly unchanged as the environment grows.

Verify Node Connectivity

Check the Tailscale status from any node:

tailscale status

Example validation tests:

ping parents
ping inlaws
ping adminserver

If MagicDNS is enabled, node names can be used instead of Tailscale IP addresses.

Validate Tailscale SSH

From the admin MacBook:

ssh alindanger@parents

Expected result:

Admin user can SSH into tagged infrastructure nodes
Non-admin users cannot SSH into infrastructure nodes unless explicitly allowed
Security Design

This project does not expose SMB, SSH, or backup services to the public internet.

Instead:

Devices authenticate to the tailnet
ACLs define allowed traffic
SSH access is controlled through Tailscale SSH policy
Backup access is limited to required services only
Result

Tailscale successfully connects isolated simulated locations and provides a secure foundation for the backup system.

This creates a practical pattern for a real-world deployment where each VM could be replaced by a physical server or NAS at a remote location.
