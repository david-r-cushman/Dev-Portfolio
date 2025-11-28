# 📦 PowerShell Modules

This folder contains PowerShell modules I’ve developed to provide **reusable automation building blocks**. Unlike standalone scripts, modules are designed for **consistency, onboarding clarity, and scalability** across multiple projects.  

Each module demonstrates my ability to refactor functions into packages that can be imported, versioned, and reused — a key skill for enterprise automation and lifecycle stewardship.

---

## 📂 Module Categories

### 🛠️ Sample
- [Sample.psm1](Sample/)  
  *Purpose:* Placeholder module created to validate portfolio navigation and README structure.  
  *Concepts Demonstrated:* Portfolio consistency, navigation clarity, and documentation flow.

---

### 📑 Logging
- [Write-ScriptError](Logging/Write-ScriptError/)  
  *Purpose:* Standardizes error logging across scripts by capturing `ErrorRecord` details and writing them to JSON, CSV, or TXT.  
  *Problem Solved:* Provides audit‑ready logs and operator visibility during automation failures.  
  *Concepts Demonstrated:*  
    - Lifecycle‑safe logging with directory checks and `-WhatIf` support  
    - Operator experience with console warnings  
    - Auditability by tying logs to the calling script name  
    - Reusable module packaging for consistency across pipelines  

---

### ⚡ Error Handling *(future expansion)*
Modules that actively manage or remediate errors (e.g., retry logic, exception wrapping, lifecycle guardrails).  
- Current status: **Draft stage** — placeholders for future portfolio expansion.  
- Focus: **Resilient automation and graceful recovery.**

---

### 🔒 Security *(future expansion)*
Modules that enforce least‑privilege principles, perform security checks, or integrate static analysis tools.  
- Current status: **Draft stage** — placeholders for future portfolio expansion.  
- Focus: **Privilege modeling, security auditing, and lifecycle‑safe automation.**

---

## 👔 Value to Employers

- **Reusable Automation**: Demonstrates ability to package functions into modules for consistency and scalability.  
- **Lifecycle Stewardship**: Modules include guardrails, error handling, and audit‑ready design.  
- **Operator Experience**: Clear console output and recruiter‑friendly documentation.  
- **Future Growth**: Categories anticipate expansion into error handling and security, showing forward‑thinking portfolio design.

---

## 🚀 How to Explore

- Navigate into each category folder (Logging, Error Handling, Security, Sample).  
- Review the README.md inside each module folder for context, usage examples, and recruiter‑friendly highlights.  
- Explore individual `.psm1` files to see reusable PowerShell functions in action.