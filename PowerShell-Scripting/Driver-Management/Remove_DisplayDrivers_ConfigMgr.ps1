<#
    .SYNOPSIS
        Remove driver packages for the "display" device class utilizing "devcon.exe" on Windows 7 or
        newer devices.  This script is intended for use with Microsoft Endpoint Configuration Manager (MECM)
        and will exit with a return code of 0 if successful, or 1 if an error occurs.  This script will
        also exit if you attempt to run it on a virtual machine, and as such, is intended for physical
        computers only.

        Devcon.exe is superior to using pnputil.exe as pnputil.exe requires that you know the exact
        name of the oem.inf (driver package) file that you wish to uninstall, which is unique to every
        install.  With devcon.exe, you can easily remove the oem.inf file by only needing to know the
        hardware id of the device you wish to remove the driver package for.  And in addition to this,
        devcon.exe allows you to easily determine the hardware id of display adapters by specifying the class
        of device, which in this case would be the "display" device class.

    .DESCRIPTION
        This script, which must be run as an Administrator, provides easy and reliable removal of display
        device driver packages by using the "devcon.exe" utility. The script will list all display devices
        and their hardware ids, then remove the driver package for each device. The script will log the
        removal of each driver package to a log file.

        Please note that the "devcon.exe" utility must be present in the same directory as this script.
        Details on where to obtain "devcon.exe" and how it is used are provided in the .LINK section.

        Display driver package removal is performed by the following steps:
        1. List all display devices and their hardware ids using "devcon.exe listclass display".

            Sample Output:
            PCI\VEN_8086&DEV_3E98&SUBSYS_09611028&REV_02\3&11583659&0&10: Intel(R) UHD Graphics 630
            PCI\VEN_10DE&DEV_1E84&SUBSYS_C7231028&REV_A1\4&45D1E59&0&0008: NVIDIA GeForce RTX 2070 SUPER

        2.  Remove the driver package for each device using "devcon.exe remove <device hardware id>".
    
            Explanation:
            Each line of Step 1. output is taken as an invidual line, and the hardware ids
            are then passed to "devcon.exe remove <device hardware id>," which then locates
            the driver package for that hardware id and removes it.  From the sample output
            shown in Step 1, the hardware ids that would be passed to "devcon.exe remove" are:
            - PCI\VEN_8086&DEV_3E98&SUBSYS_09611028&REV_02
            - PCI\VEN_10DE&DEV_1E84&SUBSYS_C7231028&REV_A1

        3.  Log the removal of each driver package to a log file named "Remove_DisplayDrivers.log".

            Sample Log Output:
            Log for Remove_DisplayDrivers.ps1 - MM/DD/YYYY HH:MM:SS
            Removing driver package: PCI\VEN_8086&DEV_3E98&SUBSYS_09611028&REV_02
            Removing driver package: PCI\VEN_10DE&DEV_1E84&SUBSYS_C7231028&REV_A1
            Successfully removed driver package: PCI\VEN_8086&DEV_3E98&SUBSYS_09611028&REV_02
            Successfully removed driver package: PCI\VEN_10DE&DEV_1E84&SUBSYS_C7231028&REV_A1

    .PARAMETER Whatif
        Used to test the script without actually removing driver packages.
        
    .INPUTS
        Not applicable

    .OUTPUTS
        A log file named "Remove_DisplayDrivers.log" will be created in the same directory as the script,
        but only only if the script is run on a physical machine.  If this log file already exists, the 
        script will append to it.  Further details are captured in the .DESCRIPTION section.
    
    .EXAMPLE
        Testing the script without actually removing driver packages.
        PS C:\> .\Remove_DisplayDrivers.ps1 -WhatIf
        
        Running the script and removing driver packages.
        PS C:\> .\Remove_DisplayDrivers.ps1

    .LINK
        This script was created with the assistance of GitHub Copilot in VS Code.
        https://code.visualstudio.com/docs/copilot/overview

        How to I obtain devcon.exe?     
        https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/devcon

        How do I use devcon.exe to list display device hardware ids?
        https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/devcon-listclass

        How do I use devcon.exe to remove a driver package using the device hardware id?
        https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/devcon-remove

    .NOTES
        Author: David R. Cushman
        Created: 07/28/2025
        Version: 1.0
        Purpose: Created as part of professional development and automation portfolio

    #>

# Require script to be run with PowerShell version 5.0 or higher
#Requires -Version 5.0

#Require script to be run as an Administrator
#Requires -RunAsAdministrator

# Enable "WhatIf" functionality to test the script without actually removing driver packages
param (
    [switch]$WhatIf
)

# Obtain SystemInfo from current computer
$systemInfo = Get-CimInstance -ClassName Win32_ComputerSystem
# Obtain Manufacturer from $systemInfo
$manufacturer = $systemInfo.Manufacturer
# Obtain Model from $systemInfo
$model = $systemInfo.Model

# List of common virtual machine manufacturers/models
$vmManufacturers = @("Microsoft Corporation", "VMware, Inc.", "Xen", "innotek GmbH", "Red Hat", "Oracle Corporation")

# Check if the manufacturer or model is in the list of virtual machine manufacturers/models and throw error if true
if ($vmManufacturers -contains $manufacturer -or $vmManufacturers -contains $model) {
    Write-Output "This script cannot be run on a virtual machine."
    exit 1
}

# Write output to the console indicating that the script is running on a physical machine
Write-Output "Running on a physical machine."

# Define the full path to devcon.exe
$devconPath = "$PSScriptRoot\devcon.exe"

# Define the log file path
$logFilePath = "$PSScriptRoot\Remove_DisplayDrivers.log"

# Initialize the log file
"Log for Remove_DisplayDrivers.ps1 - $(Get-Date)" | Out-File -FilePath $logFilePath -Append

try {
    # Run "devcon.exe listclass display" and store its output
    $output = & $devconPath listclass display

    # Ensure the output is treated as a string array
    $outputLines = $output -split "`n"

    foreach ($line in $outputLines) {
        # Trim any leading or trailing whitespace
        $trimmedLine = $line.Trim()

        # Use a regular expression to check if the line starts with a valid PCI, USB, or ACPI hardware ID pattern.
        if ($trimmedLine -match "^(PCI\\VEN_[0-9A-F]{4}&DEV_[0-9A-F]{4}(?:&SUBSYS_[0-9A-F]{8})?(?:&REV_[0-9A-F]{2})?|USB\\VID_[0-9A-F]{4}&PID_[0-9A-F]{4}(?:&REV_[0-9A-F]{4})?|ACPI\\[A-Z0-9]{4}(?:&\w{4})?)") {
            #If a match is found, the full matched hardware ID is stored here.
            $hardwareID = $Matches[0]
        } else {
            "Info: Skipping line (no valid hardware ID pattern found): '$trimmedLine'" | Out-File -FilePath $logFilePath -Append
            continue
        }

            # Log the action
            "Removing driver package: $hardwareID" | Out-File -FilePath $logFilePath -Append

            if ($WhatIf) {
                # Log the WhatIf action
                "WhatIf: Would remove driver package: $hardwareID" | Out-File -FilePath $logFilePath -Append
            } else {
                # Use devcon.exe to remove the driver package (devcon.exe remove <device hardware id>)
                $removeOutput = & $devconPath remove $hardwareID

                # Log the output of the remove command
                $removeOutput | Out-File -FilePath $logFilePath -Append
            }
        }

    # If the script reaches this point, it succeeded
    "Script completed successfully." | Out-File -FilePath $logFilePath -Append
    exit 0
    # If an error occurs, log the error and exit with a return code of 1
} catch {
    # Log the error
    "Script failed with error: $($_.Exception.Message)" | Out-File -FilePath $logFilePath -Append
    exit 1
}