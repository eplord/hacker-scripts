function Test-DLL {
    <#
.SYNOPSIS
Helper script for checking DLLs

.DESCRIPTION
This script does three things:
- displays build configuration
- displays target CPU information
- displays informtaion about Jit Optimization

.PARAMETER StartPath
Location of the folder where your DLLs live.

.EXAMPLE
.\Test-DLL.ps1 "C:\dll" -CleanHost
Clears console and then displays information about all DLLs located in "C:\\dll"

.EXAMPLE
.\Test-DLL.ps1 "C:\dll"
Displays information about all DLLs located in "C:\\dll"
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StartPath,
        [Parameter(Mandatory = $false)]
        [switch]$CleanHost
    )

    process {
        if (!(Test-Path $StartPath)) {
            Write-Host "Incorrect folder path:" -ForegroundColor Red
            Write-Host "$StartPath" -ForegroundColor Red
            exit
        }
        if ($CleanHost) {
            Clear-Host
        }

        Import-Module DLLInfo
        Get-ChildItem $StartPath | % {
            Write-Host $_.FullName -ForegroundColor Green
            $versionInfo = (Get-Item $_.FullName).VersionInfo
            $versionInfo.ProductVersion
            $versionInfo.FileVersion
            $versionInfo.LegalCopyright

            $buildConfiguration = Get-BuildConfiguration $_.FullName
            $targetCPU = Get-TargetCPU $_.FullName
            $jitOptimized = Test-JitOptimized $_.FullName

            Write-Host "BuildConfiguration`t [$buildConfiguration]" -ForegroundColor Yellow
            Write-Host "TargetCPU`t`t [$targetCPU] " -ForegroundColor Yellow
            Write-Host "JitOptimized`t`t [$jitOptimized]" -ForegroundColor Yellow
            write-host ""
        }
    }
}