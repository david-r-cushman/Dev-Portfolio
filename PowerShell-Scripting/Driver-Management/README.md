# 🖥️ Uninstall-DisplayDrivers.ps1

## 💼 Purpose

Efficiently and accurately uninstall display driver packages from physical Windows devices using `devcon.exe` and PowerShell. I originally created this script while engineering a **Windows 7 → Windows 10 in‑place upgrade project**, managed through **Microsoft Configuration Manager (ConfigMgr, MECM, SCCM)**.

The in‑place upgrade process from Windows 7 to Windows 10 was known to be incompatible if Windows 7 display drivers were present. This script enabled streamlined driver management without manual `oem.inf` identification. By reliably and accurately automating the uninstall of display drivers before the upgrade, the in-place upgrade process could continue successfully, **eliminating a major blocker in the enterprise OS migration.**  

## 🔍 Why It Matters

In‑place upgrades were sensitive to driver compatibility. Display drivers in particular caused the Windows 10 setup engine to error out and quit. This script automated the uninstall of display driver packages by leveraging hardware IDs, ensuring that upgrades proceeded smoothly without manual intervention.  

By embedding this into the **ConfigMgr in‑place upgrade task sequence**, I was able to significantly reduce upgrade failures, minimize technician effort, and improve overall deployment success rates, all under strict change‑management controls.

## 🛠 Features

- 🖥️ Detects all display adapters via `devcon listclass display`
- 🧹 Uninstalls corresponding driver packages with `devcon remove`
- 🧠 Skips execution on virtual machines
- 🧪 Supports dry-run testing with `-WhatIf` and `-Confirm`
- 🧾 **Help-Enabled**: Includes PowerShell comment-based help for integration with `Get-Help`, complete with `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, and usage examples
- 📊 Granular exit codes for lifecycle-safe automation reporting

## 📘 Background & Growth Story

This script was originally created by me during a **Large-Scale OS Migration project** where I engineered the upgrade of 3,000 Windows 7 devices to Windows 10 using **Microsoft Configuration Manager**. The in‑place upgrade process would fail if legacy display drivers were present, and therefore I created this script to automatically uninstall display drivers before running the upgrade, solving a critical blocker in the migration workflow.

This project is documented in my resume under **Key Projects and Achievements: Large-Scale OS Migration**, where the overall initiative delivered an estimated $1.2M in cost savings by minimizing user disruption, reducing labor overhead, and streamlining workflows. This script was one of the automation tools that enabled that success.

It was also one of the very first PowerShell scripts I ever created. I developed it with guidance from a senior administrator who served as an unofficial mentor, helping me translate manual processes into automation. That collaboration sparked my deeper study of PowerShell and lifecycle‑safe scripting practices. This portfolio version is a refined recreation of that original script, updated to demonstrate lifecycle‑safe design and my growth in PowerShell expertise.

Since then, I’ve refined the script through study and practice:
- Removed unnecessary logging
- Implemented proper `-WhatIf`/`-Confirm` support
- Scoped regex patterns to display drivers only
- Documented lifecycle-safe exit codes
- Structured help documentation to align with PowerShell standards

This version showcases my growth in PowerShell expertise, technical decision-making, and the ability to turn manual processes into scalable, automated solutions.

## 👔 Value to Employers

| Competency                 | Why It Matters                                      |
|-----------------------------|-----------------------------------------------------|
| **PowerShell Automation**   | Reduces manual effort and human error                |
| **Enterprise-Ready Code**   | Built for use with ConfigMgr & OS deployments             |
| **Tool Selection**          | Chose devcon.exe for flexibility and accuracy        |
| **Lifecycle-Safe Design**   | Granular exit codes and guardrails for VM detection  |
| **Change-Management Alignment** | Script only uninstalls display drivers, ensuring scope control and auditability |
| **Script Scalability**      | Regex patterns documented for future device classes  |
| **Documentation Practices** | Help-enabled script supports discoverability and maintainability |

## ⚙️ Requirements

- ✅ PowerShell 5.0+
- ✅ Administrator privileges
- ✅ `devcon.exe` in the same folder as the script  
  👉 [Download devcon.exe from Microsoft](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/devcon)

## 🧪 Parameters

| Parameter | Description                                     |
|-----------|-------------------------------------------------|
| `-WhatIf` | Simulates driver uninstall without making changes |
| `-Confirm` | Prompts for confirmation before uninstalling drivers |

## 💻 Example Usage

```powershell
# Dry-run for testing purposes
.\Uninstall-DisplayDrivers.ps1 -WhatIf

# Actual execution
.\Uninstall-DisplayDrivers.ps1
```