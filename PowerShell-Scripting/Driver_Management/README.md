# 🧹 Remove_DisplayDrivers_ConfigMgr.ps1

## 💼 Purpose

Efficiently remove display driver packages from physical Windows devices using `devcon.exe` and PowerShell. Originally built for a successful **Windows 7 to Windows 10 in-place upgrade** using **ConfigMgr (Microsoft Configuration Manager, AKA "SCCM")**, this tool enables streamlined driver management without manual `oem.inf` identification.

## 🔍 Why It Matters

Driver cleanup can make or break OS upgrade stability. This script automates the removal of display driver packages by leveraging hardware IDs — eliminating tedious, error-prone manual steps and reducing upgrade failures.

## 🛠 Features

- 🖥️ Detects all display adapters via `devcon listclass display`
- 🧹 Removes corresponding driver packages with `devcon remove`
- 📄 Logs each action in `Remove_DisplayDrivers.log`
- 🧠 Skips execution on virtual machines
- 🧪 Supports dry-run testing with `-WhatIf`
- 🧾 **Help-Enabled**: Includes PowerShell comment-based help for integration with `Get-Help`, complete with `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, and usage examples

## 📘 Background & Growth Story

This script began during a real-world Windows migration project. At the time, I had no experience with PowerShell — but I had a strong drive to improve efficiency. After identifying `devcon.exe` as the best solution for display driver cleanup, a senior server administrator mentored me through automating the process.

That experience became a foundation for deeper PowerShell expertise. This version of the script is a **recreation and extension** of my original work — built to showcase my growth, technical decision-making, and the ability to turn manual processes into scalable, automated solutions.

## 👔 Value to Employers

| Competency             | Why It Matters                                |
|------------------------|-----------------------------------------------|
| **PowerShell Automation** | Reduces manual effort and human error            |
| **Enterprise-Ready Code** | Built for use with ConfigMgr & OS deployments         |
| **Tool Selection**        | Chose devcon.exe for flexibility and accuracy    |
| **Mentorship-Driven Learning** | Demonstrates collaborative growth and initiative |
| **Script Scalability**     | Can be extended to other device classes          |
| **Documentation Practices** | Help-enabled script supports discoverability and maintainability |

## ⚙️ Requirements

- ✅ PowerShell 5.0+
- ✅ Administrator privileges
- ✅ `devcon.exe` in the same folder as the script  
  👉 [Download devcon.exe from Microsoft](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/devcon)

## 🧪 Parameters

| Parameter | Description                                     |
|----------|-------------------------------------------------|
| `-WhatIf` | Simulates driver removal without making changes |

## 💻 Example Usage

```powershell
# Dry-run for testing purposes
.\Remove_DisplayDrivers_ConfigMgr.ps1 -WhatIf

# Actual execution
.\Remove_DisplayDrivers_ConfigMgr.ps1