﻿<#
.SYNOPSIS
    Extract version from File if available

.DESCRIPTION
    Extract the informations from a file and output the version.

.PARAMETER url
    The url to the file (required for remote file)

.PARAMETER File
    Location of the file (for files already on disk)

.OUTPUTS
    The version of the file if it is available.
    The Hash
    The algorythm used
    The File Size in MB
    The File Name
#>
function Get-FileVersion {
    param(
        [string]$url,
        [string]$File,
        [string]$checksumType = "SHA512",
        [switch]$keep
    )
    if($env:ChocolateyChecksumType) { $checksumType = $env:ChocolateyChecksumType }

    if($url.Trim().Length -gt 0) {
        $tempFile = Join-Path $env:TEMP $($url.split('/')[-1])
        import-module C:\ProgramData\chocolatey\helpers\chocolateyInstaller.psm1 -ErrorAction SilentlyContinue -Force
        try {
            $FileName = Get-WebFileName -url $url -defaultName $($url.split('/')[-1])
            $tempFile = Join-Path $env:TEMP $FileName
        }
        catch {
            $FileName = $null
        }

        if($tempFile -match '\?') {
            $tempFile = $tempFile.Split('?')[0]
        }
        Invoke-WebRequest -Uri $url -OutFile $tempFile
        try {
            if($([System.Diagnostics.FileVersionInfo]::GetVersionInfo($tempFile).ProductVersion).trim().Length -eq 0) {
                [version]$version=$([System.Diagnostics.FileVersionInfo]::GetVersionInfo($tempFile).FileVersion).trim()
            } else {
                [version]$version=$([System.Diagnostics.FileVersionInfo]::GetVersionInfo($tempFile).ProductVersion).trim()
            }
            $FileSize = (((Get-Item -Path $tempFile).Length)/1MB)
        }
        catch {
            $version=$null
        }
        if($null -eq $version -and $null -ne $url) {
            $version = (Get-Version $url).Version
        }
        try {
            $FileSize = (((Get-Item -Path $tempFile).Length)/1MB)
        }
        catch {
            $FileSize=$null
        }
        $checksum = (Get-FileHash -Path $tempFile -Algorithm $checksumType).Hash
        if(! $keep) {
            Remove-Item -Path $tempFile -Force
            $tempFile = "Removed"
        }
    } else {
        try {
            if($([System.Diagnostics.FileVersionInfo]::GetVersionInfo($tempFile).ProductVersion).trim().Length -eq 0) {
                [version]$version=$([System.Diagnostics.FileVersionInfo]::GetVersionInfo($File).FileVersion).trim()
            } else {
                [version]$version=$([System.Diagnostics.FileVersionInfo]::GetVersionInfo($File).ProductVersion).trim()
            }
        }
        catch {
            $version=$null
        }
        $checksum = (Get-FileHash -Path $File -Algorithm $checksumType).Hash
    }

    $result = @{Version = $version; Checksum = $checksum; ChecksumType = $checksumType; TempFile = $tempFile; FileSize = $FileSize; FileName = $FileName}
    return $result
}
