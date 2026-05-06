# AI Usage Disclosure

## Overview

AI tools were used during this project as a productivity and documentation assistant. The primary goal was to improve clarity, structure, and efficiency while maintaining full ownership of the implementation, testing, and final validation.

---

## What AI Was Used For

AI was used to assist with:

* Refining rough drafts of documentation
* Structuring the GitHub repository and organizing content
* Reviewing and improving clarity of setup instructions
* Debugging issues and suggesting potential fixes
* Drafting scripts and improving formatting
* Converting architecture descriptions into visual diagrams
* Reducing the amount of manual typing required

Most initial drafts and large portions of written documentation were generated or refined with AI assistance, followed by manual review and correction.

---

## What I Reviewed and Changed

All AI-generated output was reviewed and iteratively refined.

My workflow was:

1. Quickly document or implement a process myself
2. Use AI to refine structure and readability
3. Review the output for accuracy
4. Provide feedback and corrections to the AI
5. Repeat until the result matched the real environment

I made adjustments to ensure:

* Commands matched the actual system configuration
* Architecture accurately reflected the implemented environment
* Scripts worked in practice, not just in theory
* Documentation aligned with real-world behavior

---

## Where AI Was Most Helpful

AI provided the most value in:

* Saving time on documentation writing and formatting
* Structuring step-by-step setup guides
* Improving readability and organization of the repository
* Assisting with Tailscale ACL structure and syntax

This allowed me to focus more on implementation, testing, and troubleshooting rather than manual writing.

---

## Where AI Was Wrong, Incomplete, or Misleading

AI occasionally made incorrect assumptions about the environment, networking model, and security boundaries.

Key examples:

* **Incorrect network isolation design**

  * AI recommended isolating each Proxmox network using separate bridges without internet access, relying only on Tailscale connectivity
  * This failed because Tailscale requires internet access for authentication and coordination
  * The recommendation treated Tailscale like a full tunnel VPN rather than a coordination-based mesh network

  This led to:

  * Repeated attempts to fix scripts instead of identifying the root cause
  * Misleading troubleshooting suggestions (e.g., DHCP issues in an environment with no upstream connectivity)

  The issue was resolved by recognizing that:

  * Nodes could not reach the Tailscale control plane
  * The architecture needed to allow outbound internet access

---

* **Incorrect assumptions about trust boundaries**

  * AI repeatedly attempted to test and configure direct connectivity between the Parents and In-laws environments
  * This conflicted with the intended design, where each site is isolated and only communicates with the central admin server

  In the real-world scenario:

  * Parents should not have access to In-laws systems
  * Backup data should not be directly shared between sites
  * Each location should only replicate to the central admin server

  This required:

  * Ignoring AI suggestions that violated access control boundaries
  * Designing the architecture to enforce separation between environments
  * Ensuring Tailscale ACLs and network flows reflected real-world trust models

---

* **Overfitting troubleshooting to scripts**

  * AI often assumed issues were caused by script errors rather than architectural problems
  * This led to repeated script modifications instead of identifying underlying network design issues

  Resolution required stepping back from the suggested fixes and validating the full system design.

---

These issues reinforced the importance of validating AI suggestions against real-world requirements, especially around networking and security design.

---

## How the Final Result Was Verified

All components of the solution were tested in a live environment, including:

* Tailscale connectivity between nodes
* SSH access using Tailscale
* Backup workflows using rsync
* Off-site replication to the admin server
* File verification on the destination system

Testing was performed end-to-end to confirm that the system worked as documented.

---

## Perspective on Using AI

AI was used as a drafting and support tool, not as a source of truth.

All outputs were treated as suggestions and required validation.
Final decisions, architecture design, and troubleshooting were performed manually based on actual system behavior.

---

## Summary

AI significantly improved speed and documentation quality, but required careful review and validation. The final implementation reflects hands-on configuration, testing, and problem-solving beyond AI-generated suggestions.
