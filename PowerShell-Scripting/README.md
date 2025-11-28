# 🖥️ PowerShell Scripting – Driver Management

This folder contains PowerShell scripts I developed to automate the management of Windows device drivers. These examples highlight my ability to solve **real enterprise blockers** (such as display driver incompatibilities during OS upgrades) with lifecycle‑safe automation and clear documentation.

---

## 📂 Featured Scripts

### [Sample.ps1](Sample/)
- **Purpose:** Placeholder script to validate README navigation.  
- **Concepts Demonstrated:** Portfolio navigation and documentation clarity.

---

### [Uninstall-DisplayDrivers.ps1](Driver-Management/)
- **Purpose:** Automates the uninstall of display driver packages using `devcon.exe` to enable successful **Windows 7 → Windows 10 in‑place upgrades**.  
- **Problem Solved:** Legacy display drivers caused upgrade failures; this script removed both the device and its `oem.inf` package to prevent reinstallation after reboot.  
- **Concepts Demonstrated:**  
  - Lifecycle‑safe automation with `-WhatIf`/`-Confirm` support  
  - Guardrails for VM detection  
  - Granular exit codes for auditability  
  - Recruiter‑friendly documentation linking technical depth to business impact  

---

## 👔 Value to Employers

- **Problem-Solving:** Demonstrates ability to identify and resolve upgrade blockers in enterprise environments.  
- **Lifecycle-Safe Design:** Scripts include guardrails, error handling, and audit‑ready exit codes.  
- **Operator Experience:** Clear console output and documentation for onboarding clarity.  
- **Strategic Storytelling:** Each artifact connects technical implementation to business outcomes (e.g., reduced upgrade failures, cost savings).  

---

## 🚀 How to Explore

- Start with **Uninstall-DisplayDrivers.ps1** to see a real-world automation artifact tied to enterprise OS migrations.  
- Review the README inside each script folder for detailed context, usage examples, and recruiter‑friendly highlights.  