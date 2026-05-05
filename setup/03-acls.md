# Tailscale ACL Configuration

## Overview

This project uses Tailscale ACLs, groups, and tags to enforce least-privilege access across the backup environment.

The goal is not to allow every device to talk to every other device. Instead, access is intentionally limited based on user role and device purpose.

## Access Goals

| Role | Access |
|---|---|
| Admin | Full access to all nodes |
| Parent client | SMB backup access to parents backup server only |
| In-law client | SMB backup access to in-laws backup server only |
| Backup servers | Limited replication access to admin server |
| End users | No SSH access |

## Groups

Groups represent users.

```json
"groups": {
  "group:Parents": ["morgan.r.schmidt@gmail.com"],
  "group:Inlaws": []
}
Tags

Tags represent device roles.

Tag	Purpose
tag:admin	Admin systems and admin client devices
tag:parents-backup	Parents backup server
tag:inlaws-backup	In-laws backup server
tag:parents-client	Parent client devices
tag:inlaws-client	In-law client devices
Tag Owners

Only the admin account can assign tags.

"tagOwners": {
  "tag:admin": ["alindanger@live.no"],
  "tag:parents-backup": ["alindanger@live.no"],
  "tag:inlaws-backup": ["alindanger@live.no"],
  "tag:parents-client": ["alindanger@live.no"],
  "tag:inlaws-client": ["alindanger@live.no"]
}
Grants

Grants define network access.

"grants": [
  {
    "src": ["alindanger@live.no", "tag:admin"],
    "dst": ["*"],
    "ip": ["*"]
  },
  {
    "src": ["group:Parents", "tag:parents-client"],
    "dst": ["tag:parents-backup"],
    "ip": ["tcp:445"]
  },
  {
    "src": ["group:Inlaws", "tag:inlaws-client"],
    "dst": ["tag:inlaws-backup"],
    "ip": ["tcp:445"]
  },
  {
    "src": ["tag:parents-backup"],
    "dst": ["tag:admin"],
    "ip": ["tcp:22", "tcp:873", "tcp:445"]
  },
  {
    "src": ["tag:inlaws-backup"],
    "dst": ["tag:admin"],
    "ip": ["tcp:22", "tcp:873", "tcp:445"]
  }
]
Tailscale SSH

SSH access is restricted to the admin identity only.

"ssh": [
  {
    "action": "accept",
    "src": ["alindanger@live.no", "tag:admin"],
    "dst": ["tag:admin", "tag:parents-backup", "tag:inlaws-backup"],
    "users": ["alindanger"]
  }
]
Full ACL Example
{
  "groups": {
    "group:Parents": ["morgan.r.schmidt@gmail.com"],
    "group:Inlaws": []
  },

  "tagOwners": {
    "tag:admin": ["alindanger@live.no"],
    "tag:parents-backup": ["alindanger@live.no"],
    "tag:inlaws-backup": ["alindanger@live.no"],
    "tag:parents-client": ["alindanger@live.no"],
    "tag:inlaws-client": ["alindanger@live.no"]
  },

  "grants": [
    {
      "src": ["alindanger@live.no", "tag:admin"],
      "dst": ["*"],
      "ip": ["*"]
    },
    {
      "src": ["group:Parents", "tag:parents-client"],
      "dst": ["tag:parents-backup"],
      "ip": ["tcp:445"]
    },
    {
      "src": ["group:Inlaws", "tag:inlaws-client"],
      "dst": ["tag:inlaws-backup"],
      "ip": ["tcp:445"]
    },
    {
      "src": ["tag:parents-backup"],
      "dst": ["tag:admin"],
      "ip": ["tcp:22", "tcp:873", "tcp:445"]
    },
    {
      "src": ["tag:inlaws-backup"],
      "dst": ["tag:admin"],
      "ip": ["tcp:22", "tcp:873", "tcp:445"]
    }
  ],

  "ssh": [
    {
      "action": "accept",
      "src": ["alindanger@live.no", "tag:admin"],
      "dst": ["tag:admin", "tag:parents-backup", "tag:inlaws-backup"],
      "users": ["alindanger"]
    }
  ]
}
Validation

The ACL was validated with the following tests:

Test	Expected Result
Admin SSH to parents backup	Allowed
Admin SSH to in-laws backup	Allowed
Parent client SMB to parents backup	Allowed
Parent client SSH to parents backup	Denied
Parent client access to in-laws backup	Denied
Parent client access to admin server	Denied
Result

This ACL design enforces least-privilege access while still allowing the backup workflow to function.


Commit message:

```text
Add Tailscale ACL documentation
