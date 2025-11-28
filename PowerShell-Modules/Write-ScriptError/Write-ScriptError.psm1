# Require script to be run with PowerShell version 3.0 or higher
#requires -Version 3.0
function Write-ScriptError {
<#
.SYNOPSIS
    Logs details from a caught ErrorRecord to a file and displayes a warning in the console.

.DESCRIPTION
    Write-ScriptError accepts an ErrorRecord object (typically from a try/catch block), extracts
    key properties, and writes them to a log file in the specified directory. The log filename is
    built from the caller-provided ScriptName and the chosen LogFormat. Supported formats are
    Json, Csv, and Txt. A warning message is also displayed in the console for operator visibility.
    The function supports -WhatIf for safe preview of actions.

    To capture the calling script's name automatically, declare the following at the top
    of your script:   
        # Derive script name automatically
        $ScriptName = (Split-Path -Leaf $PSCommandPath) -replace '\.ps1$', ''
    You can then pass this variable into Write-ScriptError using -ScriptName $ScriptName.

.PARAMETER ErrorRecord
    The ErrorRecord object captured by the catch block (e.g., $_).

.PARAMETER LogPath
    The directory path where the log file will be created.

.PARAMETER LogFormat
    The format of the log file output. Valid values are:
    - Json
    - Csv
    - Txt
    Default: Json

.PARAMETER ScriptName
    The base name of the calling script (without extension).
    Used to build the log filename so logs reflect the script that produced the error.

.EXAMPLE
    Function already available (inline or imported as a module)

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

    In this example, the function is already available (inline or via a module).
    The script derives its own name and passes it to Write-ScriptError. The error details are logged to
    "C:\Logs\Get-VM_Test.json" and a warning message is written to the console.

.EXAMPLE
    Function loaded from external script
    
    # Load the Write-ScriptError function from external script
    . "$PSScriptRoot\Write-ScriptError.ps1"

    # Derive script name automatically
    $ScriptName = (Split-Path -Leaf $PSCommandPath) -replace '\.ps1$', ''
    $LogPath = "C:\Logs"
    $LogFormat = "Json"

    Try {
        Get-VM -Name BadVM -ErrorAction Stop
    }
    Catch {
        $_ | Write-ScriptError -LogPath $LogPath -LogFormat $LogFormat -ScriptName $ScriptName
    }
 
    In this example, the function is dot-sourced from an external script before use. The script derives its
    own name ("Get-VM_Test") once at the top and passes it to Write-ScriptError. The error details are logged
    to "C:\Logs\Get-VM_Test.json" and a warning message is written to the console.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
[OutputType([pscustomobject])]
param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [System.Management.Automation.ErrorRecord]$ErrorRecord,

    [Parameter(Mandatory=$true)]
    [string]$LogPath,   # Directory only

    [Parameter(Mandatory=$false)]
    [ValidateSet('Json','Csv','Txt')]
    [string]$LogFormat = 'Json',

    [Parameter(Mandatory=$true)]
    [string]$ScriptName
)

process {
    # Extract error details
    $Details = [pscustomobject]@{
        Timestamp     = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Level         = 'FATAL'
        ExceptionType = $ErrorRecord.Exception.GetType().FullName
        Message       = $ErrorRecord.Exception.Message
        Script        = $ErrorRecord.InvocationInfo.ScriptName
        LineNumber    = $ErrorRecord.InvocationInfo.ScriptLineNumber
        TargetObject  = $ErrorRecord.TargetObject
    }

    # Determine extension based on LogFormat
    $Extension = switch ($LogFormat) {
        'Json' { 'json' }
        'Csv'  { 'csv' }
        'Txt'  { 'txt' }
    }

    # Build full path: directory + caller script name + extension
    $FullLogPath = Join-Path -Path $LogPath -ChildPath "$ScriptName.$Extension"

    # Ensure the directory exists
    if (-not (Test-Path $LogPath)) {
        if ($PSCmdlet.ShouldProcess($LogPath, "Create directory")) {
            try {
                New-Item -ItemType Directory -Path $LogPath -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Warning "Unable to create log directory at $LogPath. Error: $($_.Exception.Message)"
                return
            }
        }
    }

    # Verify write permission
    if ($PSCmdlet.ShouldProcess($LogPath, "Verify write permission")) {
        try {
            $TestFile = Join-Path -Path $LogPath -ChildPath "permission_test.tmp"
            Set-Content -Path $TestFile -Value "test" -ErrorAction Stop
            Remove-Item $TestFile -Force -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "No write permission to $LogPath. Error: $($_.Exception.Message)"
            return
        }
    }

    # Branch logic for log format
    switch ($LogFormat) {
        'Json' {
            if ($PSCmdlet.ShouldProcess($FullLogPath, "Write JSON log entry")) {
                $Details | ConvertTo-Json -Depth 3 | Out-File -Append -FilePath $FullLogPath -Encoding UTF8 -Force
            }
        }
        'Csv' {
            if ($PSCmdlet.ShouldProcess($FullLogPath, "Write CSV log entry")) {
                if (-not (Test-Path $FullLogPath)) {
                    $Details | Export-Csv -Path $FullLogPath -NoTypeInformation -Encoding UTF8 -Force
                } else {
                    $Details | Export-Csv -Append -Path $FullLogPath -NoTypeInformation -Encoding UTF8 -Force
                }
            }
        }
        'Txt' {
            if ($PSCmdlet.ShouldProcess($FullLogPath, "Write TXT log entry")) {
                $DetailsString = ($Details | Format-List | Out-String)
                Add-Content -Path $FullLogPath -Value $DetailsString -Force
            }
        }
    }

    # Write a Warning to the console (for the human/transcript)
    Write-Warning "FATAL: Error logged to $FullLogPath.`nError details: $($ErrorRecord.Exception.Message)"
}
}