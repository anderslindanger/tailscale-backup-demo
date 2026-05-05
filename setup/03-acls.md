# Tailscale ACL Setup

## Overview

This document defines the Tailscale access-control policy used in this lab.

The goal is to control access based on **identity and device role**, not IP address or physical network location.

This ACL policy controls:

* Admin access
* Parent client access
* In-laws client access
* Backup server replication access
* Tailscale SSH permissions

---

## Access Design

| Source                     | Destination           | Purpose                    | Allowed Access  |
| -------------------------- | --------------------- | -------------------------- | --------------- |
| Admin user / admin devices | All devices           | Full administration        | All ports       |
| Parents users / clients    | Parents backup server | Time Machine / SMB backups | TCP 445         |
| In-laws users / clients    | In-laws backup server | Time Machine / SMB backups | TCP 445         |
| Parents backup server      | Admin server          | Off-site replication       | TCP 22, TCP 873 |
| In-laws backup server      | Admin server          | Off-site replication       | TCP 22, TCP 873 |

---

## Groups

Groups are used to identify end users.

```json
"groups": {
  "group:parents": ["morgan.r.schmidt@gmail.com"],
  "group:inlaws": []
}
```

### Purpose

* `group:parents` contains users allowed to access the parents backup server
* `group:inlaws` is reserved for future in-laws users

---

## Tags

Tags are used to identify device roles.

```json
"tagOwners": {
  "tag:admin":          ["alindanger@live.no"],
  "tag:parents-backup": ["alindanger@live.no"],
  "tag:inlaws-backup":  ["alindanger@live.no"],
  "tag:parents-client": ["alindanger@live.no"],
  "tag:inlaws-client":  ["alindanger@live.no"]
}
```

### Tag Purpose

| Tag                  | Purpose                                   |
| -------------------- | ----------------------------------------- |
| `tag:admin`          | Admin server and admin-controlled systems |
| `tag:parents-backup` | Parents backup server                     |
| `tag:inlaws-backup`  | In-laws backup server                     |
| `tag:parents-client` | Parents client devices                    |
| `tag:inlaws-client`  | In-laws client devices                    |

In this lab, all tags are owned by:

```text
alindanger@live.no
```

This means only the admin account can assign these tags.

---

## Grants

The ACL uses grants to define network access between users, groups, and tagged devices.

---

### Admin Access

```json
{
  "src": ["alindanger@live.no", "tag:admin"],
  "dst": ["*"],
  "ip":  ["*"]
}
```

This allows the admin user and admin-tagged devices to access all nodes and services.

This is used for:

* Lab administration
* Troubleshooting
* SSH management
* Backup validation

---

### Parents Client Access

```json
{
  "src": ["group:parents", "tag:parents-client"],
  "dst": ["tag:parents-backup"],
  "ip":  ["tcp:445"]
}
```

This allows parents users and parents client devices to access only the parents backup server over SMB.

TCP port `445` is used for SMB file sharing, which supports Time Machine backups.

---

### In-laws Client Access

```json
{
  "src": ["group:inlaws", "tag:inlaws-client"],
  "dst": ["tag:inlaws-backup"],
  "ip":  ["tcp:445"]
}
```

This allows in-laws users and in-laws client devices to access only the in-laws backup server over SMB.

The group is currently empty but included to show how the design scales.

---

### Parents Backup Replication

```json
{
  "src": ["tag:parents-backup"],
  "dst": ["tag:admin"],
  "ip":  ["tcp:22", "tcp:873"]
}
```

This allows the parents backup server to replicate backup data to the admin server.

Allowed ports:

| Port    | Purpose              |
| ------- | -------------------- |
| TCP 22  | SSH / rsync over SSH |
| TCP 873 | rsync daemon traffic |

---

### In-laws Backup Replication

```json
{
  "src": ["tag:inlaws-backup"],
  "dst": ["tag:admin"],
  "ip":  ["tcp:22", "tcp:873"]
}
```

This allows the in-laws backup server to replicate backup data to the admin server.

Allowed ports:

| Port    | Purpose              |
| ------- | -------------------- |
| TCP 22  | SSH / rsync over SSH |
| TCP 873 | rsync daemon traffic |

---

## Tailscale SSH Rules

Tailscale SSH is used to manage SSH access through the tailnet policy.

---

### Admin SSH Access

```json
{
  "action": "accept",
  "src":    ["alindanger@live.no", "tag:admin"],
  "dst":    ["tag:admin", "tag:parents-backup", "tag:inlaws-backup"],
  "users":  ["alindanger", "backupuser"]
}
```

This allows the admin user and admin-tagged devices to SSH into:

* `adminserver`
* `parents`
* `inlaws`

Allowed Linux users:

* `alindanger`
* `backupuser`

---

### Parents Backup SSH to Admin Server

```json
{
  "action": "accept",
  "src":    ["tag:parents-backup"],
  "dst":    ["tag:admin"],
  "users":  ["backupuser"]
}
```

This allows the parents backup server to SSH into the admin server as:

```text
backupuser
```

This supports automated backup replication.

---

### In-laws Backup SSH to Admin Server

```json
{
  "action": "accept",
  "src":    ["tag:inlaws-backup"],
  "dst":    ["tag:admin"],
  "users":  ["backupuser"]
}
```

This allows the in-laws backup server to SSH into the admin server as:

```text
backupuser
```

This also supports automated backup replication.

---

## Full ACL Policy

```json
{
  "groups": {
    "group:parents": ["morgan.r.schmidt@gmail.com"],
    "group:inlaws": []
  },

  "tagOwners": {
    "tag:admin":          ["alindanger@live.no"],
    "tag:parents-backup": ["alindanger@live.no"],
    "tag:inlaws-backup":  ["alindanger@live.no"],
    "tag:parents-client": ["alindanger@live.no"],
    "tag:inlaws-client":  ["alindanger@live.no"]
  },

  "grants": [
    {
      "src": ["alindanger@live.no", "tag:admin"],
      "dst": ["*"],
      "ip":  ["*"]
    },

    {
      "src": ["group:parents", "tag:parents-client"],
      "dst": ["tag:parents-backup"],
      "ip":  ["tcp:445"]
    },

    {
      "src": ["group:inlaws", "tag:inlaws-client"],
      "dst": ["tag:inlaws-backup"],
      "ip":  ["tcp:445"]
    },

    {
      "src": ["tag:parents-backup"],
      "dst": ["tag:admin"],
      "ip":  ["tcp:22", "tcp:873"]
    },

    {
      "src": ["tag:inlaws-backup"],
      "dst": ["tag:admin"],
      "ip":  ["tcp:22", "tcp:873"]
    }
  ],

  "ssh": [
    {
      "action": "accept",
      "src":    ["alindanger@live.no", "tag:admin"],
      "dst":    ["tag:admin", "tag:parents-backup", "tag:inlaws-backup"],
      "users":  ["alindanger", "backupuser"]
    },
    {
      "action": "accept",
      "src":    ["tag:parents-backup"],
      "dst":    ["tag:admin"],
      "users":  ["backupuser"]
    },
    {
      "action": "accept",
      "src":    ["tag:inlaws-backup"],
      "dst":    ["tag:admin"],
      "users":  ["backupuser"]
    }
  ]
}
```

---

## Validation Tests

After saving the ACL policy, test the expected behavior.

---

### Test Admin SSH Access

From an admin device:

```bash
ssh alindanger@parents
ssh alindanger@inlaws
ssh alindanger@adminserver
```

Expected result:

```text
Access allowed
```

---

### Test Backup User SSH Access

From the parents server:

```bash
ssh backupuser@adminserver
```

From the in-laws server:

```bash
ssh backupuser@adminserver
```

Expected result:

```text
Access allowed
```

---

### Test SMB Access

From Morgan's MacBook, connect to the parents backup server over SMB:

```text
smb://<parents-tailscale-ip>
```

Expected result:

```text
Access allowed
```

The MacBook should be able to access the parents backup server but should not have general access to unrelated servers.

---

## Security Notes

This ACL policy follows the principle of least privilege.

* End users can only access their assigned backup server
* Backup servers can only replicate to the admin server
* Admin access is limited to the admin identity and admin-tagged devices
* SSH access is explicitly controlled by user and destination tag

---

## Design Outcome

This policy allows the project to simulate a realistic multi-site backup system where:

* Each family location has its own local backup server
* End users can only access their own backup location
* Backup servers can replicate off-site
* Admin access is centralized
* No services are publicly exposed

---

## Next Step

Continue to:

➡️ `04-parents-backup-and-replication.md`

The next document configures the parents backup server for local backups and off-site replication.
