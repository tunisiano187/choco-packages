$ErrorActionPreference = 'Stop'
import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1

$url32 = 'https://www.nirsoft.net/utils/pinginfoview.zip'

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function global:au_SearchReplace {
	@{
		".\legal\VERIFICATION.txt" = @{
			"(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$($Latest.URL32)>"
			"(?i)(^\s*url(32)?\:\s*).*"         = "`${1}<$($Latest.URL32)>"
			"(?i)(^\s*checksum(32)?\:\s*).*"    = "`${1}$($Latest.Checksum32)"
    		"(?i)(^\s*checksum\s*type\:\s*).*" = "`${1}$($Latest.ChecksumType32)"
        }
	}
}

function global:au_AfterUpdate($Package) {
	Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
	$File = "tools/pinginfoview.zip"
	. ..\..\scripts\Get-FileVersion.ps1
	$FileVersion = Get-FileVersion $url32 -keep
	Move-Item $FileVersion.TempFile -Destination $File
	Expand-Archive $File -DestinationPath .\piv

	$version=$(Get-Content .\piv\readme.txt | Where-Object {$_ -match '\* Version'})[0].split(' ')[2]

	$Latest = @{ URL32 = $url32; Version = $version; Checksum32 = $FileVersion.Checksum; ChecksumType32 = $FileVersion.ChecksumType }
	return $Latest
}

update -ChecksumFor none -NoCheckChocoVersion
