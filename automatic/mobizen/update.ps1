﻿$ErrorActionPreference = 'Stop'
import-module au

$release = 'https://download.mobizen.com/download/mobizen.exe'

function global:au_SearchReplace {
	@{
		'tools/chocolateyInstall.ps1' = @{
			"(^[$]url\s*=\s*)('.*')"      		= "`$1'$($Latest.URL32)'"
			"(^[$]checksum\s*=\s*)('.*')" 		= "`$1'$($Latest.Checksum32)'"
			"(^[$]checksumType\s*=\s*)('.*')" 	= "`$1'$($Latest.ChecksumType32)'"
		}
	}
}

function global:au_AfterUpdate($Package) {
	Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
	$File = Join-Path $env:TEMP "mobizen.exe"
	Invoke-WebRequest -Uri $release -OutFile $File
	$version=[System.Diagnostics.FileVersionInfo]::GetVersionInfo($File).FileVersion.trim()

	$Latest = @{ URL32 = $release; Version = $version }
	return $Latest
}

try {
    update -ChecksumFor 32
} catch {
    $ignore = "The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel."
    if ($_ -match $ignore) { Write-Output $ignore; 'ignore' } else { throw $_ }
}