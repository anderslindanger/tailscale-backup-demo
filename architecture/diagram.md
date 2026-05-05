flowchart TB
    subgraph Admin["Admin / Home Network"]
        AdminMac["Admin MacBook<br/>Admin Device<br/>tag:admin"]
        AdminServer["adminserver<br/>Off-site Backup Target<br/>Central Admin Server<br/>tag:admin"]
        AdminStorage["Off-site Backup Storage<br/>/backups/parents<br/>/backups/inlaws"]
    end

    subgraph Parents["Parents Network"]
        ParentClient["Parent MacBook<br/>Time Machine Client<br/>tag:parents-client"]
        ParentsBackup["parents<br/>Local Time Machine Backup Server<br/>tag:parents-backup"]
        ParentStorage["Local Backup Storage<br/>/backup/timemachine<br/>/backup/manual"]
    end

    subgraph Inlaws["In-laws Network"]
        InlawsClient["In-laws MacBook / Client<br/>Time Machine Client<br/>tag:inlaws-client"]
        InlawsBackup["inlaws<br/>Local Time Machine Backup Server<br/>tag:inlaws-backup"]
        InlawsStorage["Local Backup Storage<br/>/backup/timemachine<br/>/backup/manual"]
    end

    Tailnet["Tailscale Tailnet<br/>Private Encrypted Mesh Network"]

    AdminMac --> Tailnet
    AdminServer --> Tailnet
    ParentClient --> Tailnet
    ParentsBackup --> Tailnet
    InlawsClient --> Tailnet
    InlawsBackup --> Tailnet

    ParentClient -- "SMB / Time Machine<br/>TCP 445 over Tailnet" --> ParentsBackup
    InlawsClient -- "SMB / Time Machine<br/>TCP 445 over Tailnet" --> InlawsBackup

    ParentsBackup --> ParentStorage
    InlawsBackup --> InlawsStorage
    AdminServer --> AdminStorage

    ParentsBackup -- "Off-site Replication<br/>SSH + rsync over Tailnet" --> AdminServer
    InlawsBackup -- "Off-site Replication<br/>SSH + rsync over Tailnet" --> AdminServer

    AdminMac -- "Admin Access<br/>Tailscale SSH" --> AdminServer
    AdminMac -- "Admin Access<br/>Tailscale SSH" --> ParentsBackup
    AdminMac -- "Admin Access<br/>Tailscale SSH" --> InlawsBackup

    ParentClient -. "No direct access<br/>Blocked by ACL" .-> AdminServer
    ParentClient -. "No access<br/>Blocked by ACL" .-> InlawsBackup
    InlawsClient -. "No access<br/>Blocked by ACL" .-> ParentsBackup
    InlawsClient -. "No direct access<br/>Blocked by ACL" .-> AdminServer
