# Demo Script

## Overview (30 seconds)

“Today I’m going to show how I built a secure, multi-site backup system using Tailscale.

This setup simulates three separate locations:

* An admin location
* A parents home network
* An in-laws home network

The goal is to provide:

* Local backups for fast recovery
* Off-site replication for disaster protection
* Secure access without exposing anything to the internet”

---

## Step 1 — The Problem (45 seconds)

“Backing up data across multiple locations is usually complicated.

Traditional approaches require:

* Port forwarding
* VPNs
* Firewall rules
* Managing SSH keys

That creates:

* Security risks
* Operational overhead
* Fragile setups

So the question is:

👉 Can we build something that is secure, simple, and works anywhere?”

---

## Step 2 — Architecture (45 seconds)

“Here’s the environment I built.”

Explain:

* Each location has its own backup server
* Clients back up locally first
* Backup servers replicate data off-site to a central admin server

Flow:

```text
Mac → Local Backup Server → Admin Server
```

Key point:

“Even though this is running in Proxmox, this behaves exactly like three physically separate locations.”

---

## Step 3 — Tailscale Network (Live Command)

Run:

```bash
tailscale status
```

Say:

“All of these machines are connected through a private tailnet.

There are:

* No public IPs
* No open ports
* No port forwarding

Everything communicates securely over Tailscale.”

---

## Step 4 — Identity-Based Access (Important)

“This is where things get interesting.

Access is not based on IP addresses—it’s based on identity.”

Explain briefly:

* Tags = device roles
* Groups = users
* ACLs = rules

Key line:

“Not every device can talk to every other device.
Access is explicitly defined.”

---

## Step 5 — Admin Access (WOW Moment #1)

Run:

```bash
ssh alindanger@parents
```

Say:

“As an admin, I can access any system instantly.”

Highlight:

* No SSH keys configured manually
* No firewall rules
* No VPN

“This is handled entirely by Tailscale SSH and ACLs.”

---

## Step 6 — Restricted Access (Security Proof)

Explain (or optionally demo failure):

“If I were a normal user or client device:

* I cannot SSH into servers
* I cannot access other environments
* I only get access to exactly what I need”

Key line:

“This enforces least privilege by default.”

---

## Step 7 — Backup Demonstration (WOW Moment #2)

From Mac:

* Connect to:

```text
smb://parents
```

Show:

* Time Machine share appears
* Backup starts

Say:

“This is a real backup over Tailscale.

There’s:

* No public exposure
* No VPN
* No special networking setup

Just identity-based access.”

---

## Step 8 — Off-Site Replication (WOW Moment #3)

From parents server:

```bash
./backup.sh
```

Then on adminserver:

```bash
cat /backups/parents/manual/test.txt
```

Say:

“This shows data being securely replicated off-site.”

Highlight:

* Happens over tailnet
* Controlled by ACL
* No direct connectivity between environments

---

## Step 9 — SSH Without Keys (VERY STRONG POINT)

From in-laws server:

```bash
ssh backupuser@adminserver
```

Say:

“This is a big one.

Normally I would need to:

* Generate SSH keys
* Distribute them
* Maintain them

Here, I don’t.

Tailscale SSH uses identity and policy instead.”

---

## Step 10 — Security Summary (30 seconds)

“This system has:

* No open ports
* No public exposure
* Identity-based access control
* End-to-end encryption
* Least privilege enforced through ACLs”

---

## Step 11 — Real-World Application (30 seconds)

“This exact setup could be used for:

* Home backup systems
* Remote offices
* Small businesses
* Distributed teams

You can replace these VMs with real devices, and nothing changes.”

---

## Step 12 — Closing (15 seconds)

“Using Tailscale, I was able to:

* Simplify networking
* Improve security
* Remove operational complexity

While still delivering a real-world backup solution.”
