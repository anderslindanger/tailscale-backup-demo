# Tailscale Setup

## Overview

This document covers installing Tailscale on the lab servers, joining them to the tailnet, enabling Tailscale SSH, and manually applying device tags in the Tailscale Admin Console.

The ACL and access-control policy are configured in the next document.

---

## Environment

This setup uses the following nodes:

| Device             | Type             | Purpose                           | Tag                  |
| ------------------ | ---------------- | --------------------------------- | -------------------- |
| `adminserver`      | Ubuntu Server VM | Central backup replication target | `tag:admin`          |
| `parents`          | Ubuntu Server VM | Parents local backup server       | `tag:parents-backup` |
| `inlaws`           | Ubuntu Server VM | In-laws local backup server       | `tag:inlaws-backup`  |
| `Morgan's MacBook` | macOS client     | Test end-user backup client       | `tag:parents-client` |

The servers are joined using reusable Tailscale auth keys.
End-user MacBooks are invited into the tailnet and sign in normally using an identity provider such as Google or Microsoft.

---

## Why Tailscale Is Used

The VMs are on the same Proxmox network for lab simplicity, but the backup architecture is designed as if each system is in a separate physical location.

Tailscale makes the experience the same whether the systems are:

* On the same LAN
* In different homes
* Behind NAT
* On different ISPs
* In different cities

For this project, Tailscale provides:

* Encrypted private connectivity
* Device identity
* Simple SSH access
* Access control through tags and ACLs
* No port forwarding or public exposure

---

## Step 1 — Connect to Each Server Over Local SSH

Before Tailscale is installed, connect to each VM using its local DHCP address.

Example:

```bash
ssh alindanger@<local-vm-ip>
```

Repeat this for:

```bash
ssh alindanger@<adminserver-local-ip>
ssh alindanger@<parents-local-ip>
ssh alindanger@<inlaws-local-ip>
```

Once Tailscale SSH is enabled, local SSH will no longer be required for normal administration.

---

## Step 2 — Create a Reusable Auth Key

In the Tailscale Admin Console:

1. Go to the Tailscale Admin Console
2. Open **Settings**
3. Go to **Keys**
4. Create a new **auth key**
5. Use a **reusable auth key**
6. Copy the generated install/auth command

This project uses reusable keys for lab simplicity.

> In a production environment, one-time keys or pre-approved tagged keys may be preferred depending on security requirements.

---

## Step 3 — Install Tailscale on Each Server

Run the Tailscale install command on each Ubuntu server:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

Repeat on:

* `adminserver`
* `parents`
* `inlaws`

---

## Step 4 — Join Each Server to the Tailnet

After installation, authenticate each server using the reusable auth key.

Example:

```bash
sudo tailscale up --auth-key <your-auth-key>
```

Repeat this command on each server.

After the command completes, the server should appear in the Tailscale Admin Console.

---

## Step 5 — Enable Tailscale SSH

After each server is joined to the tailnet, enable Tailscale SSH.

Run this on each server:

```bash
sudo tailscale up --ssh
```

This allows SSH access to be controlled by the tailnet ACL instead of relying only on local network rules.

---

## Step 6 — Verify Tailscale Status

On each server, confirm that Tailscale is running:

```bash
tailscale status
```

You should see the other tailnet devices listed.

You can also check the server's Tailscale IP:

```bash
tailscale ip -4
```

The IP should be in the `100.x.x.x` Tailscale range.

---

## Step 7 — Manually Apply Device Tags

In the Tailscale Admin Console, manually assign the correct tag to each device.

| Device             | Tag                  |
| ------------------ | -------------------- |
| `adminserver`      | `tag:admin`          |
| `parents`          | `tag:parents-backup` |
| `inlaws`           | `tag:inlaws-backup`  |
| `Morgan's MacBook` | `tag:parents-client` |

Tagging is important because access control will be based on device role instead of only device name or IP address.

---

## Step 8 — Invite End Users

End-user devices are invited into the tailnet.

For this lab:

* One test user signs in with Google
* The admin account signs in with Microsoft
* `Morgan's MacBook` is used as the test parents client device

After the MacBook joins the tailnet, it is manually tagged as:

```text
tag:parents-client
```

This allows the ACL policy to grant it access only to the correct backup server.

---

## Step 9 — Test Tailnet Connectivity

From one server, ping another server using its Tailscale IP:

```bash
ping <tailscale-ip>
```

Example:

```bash
ping 100.x.x.x
```

You can also test by device name:

```bash
ping parents
ping inlaws
ping adminserver
```

Device names are especially useful when using Tailscale SSH.

---

## Step 10 — Test Tailscale SSH

From an admin device, test SSH access using the Tailscale device name:

```bash
ssh alindanger@parents
```

```bash
ssh alindanger@inlaws
```

```bash
ssh alindanger@adminserver
```

You can also test the backup service user:

```bash
ssh backupuser@parents
ssh backupuser@inlaws
ssh backupuser@adminserver
```

Access will depend on the ACL rules configured in the next step.

---

## Step 11 — Confirm Expected Behavior

At this stage:

* All servers should be visible in the Tailscale Admin Console
* Each server should have a Tailscale IP
* Tailscale SSH should be enabled
* Device tags should be applied manually
* Admin SSH access should work over the tailnet
* End-user devices should be joined and tagged appropriately

---

## Tailnet Placeholder

This documentation uses a placeholder for the tailnet name:

```text
<your-tailnet-name>
```

Example MagicDNS names may look like:

```text
adminserver.<your-tailnet-name>.ts.net
parents.<your-tailnet-name>.ts.net
inlaws.<your-tailnet-name>.ts.net
```

In this lab, most testing uses Tailscale IPs, while SSH commonly uses device names such as:

```text
parents
inlaws
adminserver
```

---

## Design Decision

The servers are not connected using traditional VPN tunnels, port forwarding, or firewall rules.

Instead, every device joins the same private tailnet and access is controlled through:

* Tailscale identity
* Device tags
* User groups
* ACL grants
* Tailscale SSH rules

This makes the environment portable and realistic. The same configuration works whether the devices are local VMs or physically located at different homes.

---

## Next Step

Continue to:

➡️ `03-acls.md`

The next document defines the groups, tag ownership, grants, and SSH rules that control access between devices.
