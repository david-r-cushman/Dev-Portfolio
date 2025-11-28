# 📝 Write-ScriptError Module

## 💼 Purpose

The **Write-ScriptError** module provides a reusable PowerShell function for lifecycle‑safe error logging. It accepts an `ErrorRecord` object (typically from a `try/catch` block), extracts key properties, and writes them to a log file in JSON, CSV, or TXT format.  

This module was designed to:
- Standardize error logging across scripts and automation pipelines.
- Provide operator visibility by writing warnings to the console.
- Ensure logs are tied to the calling script name for auditability.
- Support `-WhatIf` for safe preview of actions.

By packaging this as a module, error logging can be consistently imported and reused across multiple scripts, improving maintainability and onboarding clarity.

---

## 📦 Installation

1. Copy the `Write-ScriptError` folder (containing `.psm1` and `.psd1`) into a module path, e.g.:

   ```
   $env:USERPROFILE\Documents\WindowsPowerShell\Modules\
   ```

2. Import the module:

   ```powershell
   Import-Module Write-ScriptError
   ```

3. Verify availability:

   ```powershell
   Get-Command Write-ScriptError
   ```

---

## ⚙️ Function Overview

### `Write-ScriptError`

**Parameters:**
- `ErrorRecord` *(mandatory, pipeline)* — The error object from a catch block (e.g. `$_`).
- `LogPath` *(mandatory)* — Directory where the log file will be created.
- `LogFormat` *(optional)* — Output format: `Json` (default), `Csv`, or `Txt`.
- `ScriptName` *(mandatory)* — Base name of the calling script (used in log filename).

**Behavior:**
- Extracts error details: timestamp, exception type, message, script, line number, target object.
- Builds a log filename from `ScriptName` and chosen format.
- Ensures the log directory exists and verifies write permissions.
- Writes error details in the chosen format.
- Displays a warning in the console for operator visibility.

---

## 💻 Usage Examples

### Example 1: Inline or Imported Function
```powershell
# Derive script name automatically
$ScriptName = (Split-Path -Leaf $PSCommandPath) -replace '\.ps1$', ''
$LogPath = "C:\Logs"
$LogFormat = "Json"

Try {
    Get-VM -Name BadVM -ErrorAction Stop
}
Catch {
    Write-ScriptError -ErrorRecord $_ -LogPath $LogPath -LogFormat $LogFormat -ScriptName $ScriptName
}
```

### Example 2: Pipeline Input
```powershell
Try {
    Get-VM -Name BadVM -ErrorAction Stop
}
Catch {
    $_ | Write-ScriptError -LogPath "C:\Logs" -LogFormat "Csv" -ScriptName "Get-VM_Test"
}
```

---

## 👔 Value to Employers

| Competency                   | Why It Matters                                      |
|-------------------------------|-----------------------------------------------------|
| **Error Logging Standardization** | Provides consistent, reusable error handling across scripts |
| **Lifecycle-Safe Design**     | Includes directory checks, permission validation, and `-WhatIf` support |
| **Operator Experience**       | Console warnings improve visibility during execution |
| **Auditability**              | Logs tied to calling script name for traceability   |
| **Flexibility**               | Supports multiple formats (JSON, CSV, TXT)          |
| **Module Packaging**          | Demonstrates ability to structure reusable PowerShell modules |

---

## 📑 Notes

- Requires PowerShell 3.0 or higher.  
- Designed for reuse across automation pipelines and portfolio scripts.  
- This module showcases my ability to **refactor standalone functions into reusable modules**, improving maintainability and onboarding clarity.