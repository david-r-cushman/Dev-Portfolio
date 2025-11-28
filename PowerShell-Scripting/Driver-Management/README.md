# 🖥️ Uninstall-DisplayDrivers.ps1

## 💼 Purpose

Efficiently uninstall display driver packages from physical Windows devices using `devcon.exe` and PowerShell. Originally built for OS deployment scenarios with **Microsoft Endpoint Configuration Manager (ConfigMgr,MECM, SCCM)**, this tool enables streamlined driver management without manual
`oem.inf` identification.

## 🔍 Why It Matters

Driver cleanup can make or break OS upgrade stability. This script automates the uninstall of display driver packages by leveraging hardware IDs — eliminating tedious, error-prone manual steps and reducing upgrade failures.

## 🛠 Features

- 🖥️ Detects all display adapters via `devcon listclass display`
- 🧹 Uninstalls corresponding driver packages with `devcon remove`
- 🧠 Skips execution on virtual machines
- 🧪 Supports dry-run testing with `-WhatIf` and `-Confirm`
- 🧾 **Help-Enabled**: Includes PowerShell comment-based help for integration with `Get-Help`, complete with `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, and usage examples
- 📊 Granular exit codes for lifecycle-safe automation reporting

## 📘 Background & Growth Story

This script began during a real-world Windows migration project. At the time, I had limited PowerShell experience — but I had a strong drive to improve efficiency. After identifying `devcon.exe` as the best solution for display driver cleanup, I built an initial version with mentorship support.

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
| **Change-Management Allignment** | Script only uninstalls display drivers, ensuring scope control and auditability |
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