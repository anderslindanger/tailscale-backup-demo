# Architecture Diagram

## Tailscale Secure Backup Architecture

```mermaid
flowchart TB
    subgraph Admin["Admin / Home Network"]
        AdminMac["Admin MacBook<br/>tag:admin"]
        AdminServer["adminserver<br/>Central Admin + Replication Target<br/>tag:admin"]
    end

    subgraph Parents["Parents Network"]
        ParentClient["Parent MacBook<br/>tag:parents-client"]
        ParentsBackup["parents<br/>Local Time Machine Backup Server<br/>tag:parents-backup"]
        ParentStorage["Dedicated Backup Disk<br/>/mnt/backups"]
    end

    subgraph Inlaws["In-laws Network"]
        InlawsClient["In-laws Client<br/>tag:inlaws-client"]
        InlawsBackup["inlaws<br/>Local Backup Server<br/>tag:inlaws-backup"]
    end

    Tailnet["Tailscale Tailnet<br/>Private Mesh Network"]

    AdminMac --> Tailnet
    AdminServer --> Tailnet
    ParentClient --> Tailnet
    ParentsBackup --> Tailnet
    InlawsClient --> Tailnet
    InlawsBackup --> Tailnet

    ParentClient -- "SMB / Time Machine<br/>TCP 445" --> ParentsBackup
    ParentsBackup --> ParentStorage

    ParentsBackup -- "Replication<br/>SSH / rsync / SMB" --> AdminServer
    InlawsBackup -- "Replication<br/>SSH / rsync / SMB" --> AdminServer

    AdminMac -- "Tailscale SSH" --> AdminServer
    AdminMac -- "Tailscale SSH" --> ParentsBackup
    AdminMac -- "Tailscale SSH" --> InlawsBackup

    ParentClient -. "Blocked by ACL" .-> AdminServer
    ParentClient -. "Blocked by ACL" .-> InlawsBackup
    InlawsClient -. "Blocked by ACL" .-> ParentsBackup
