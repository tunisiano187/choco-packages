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
	$File = "./tools/pinginfoview.zip"
	. ..\..\scripts\Get-FileVersion.ps1
	$FileVersion = Get-FileVersion $url32 -keep
	Move-Item $FileVersion.TempFile -Destination $File
	Expand-Archive $File -DestinationPath .\piv

	$version=$(Get-Content .\piv\readme.txt | Where-Object {$_ -match '\* Version'})[0].split(' ')[2]

	$Latest = @{ URL32 = $url32; Version = $version; Checksum32 = $FileVersion.Checksum; ChecksumType32 = $FileVersion.ChecksumType }

	# Without this, Invoke-VirusTotalScan (called from au_AfterUpdate below) treats an unset
	# FileName32 as "no file tracked yet for this package" -- it re-downloads its own scratch
	# copy via Get-RemoteFiles purely to scan it, then DELETES whatever it downloaded once the
	# scan is done. That's correct for download-on-install packages, but pinginfoview.zip is
	# already embedded above via Move-Item, so the deletion strips the real file
	# chocolateyInstall.ps1 needs. Confirmed live: v3.25.0 failed verification with 7-Zip
	# unable to extract the archive because tools/pinginfoview.zip was missing from the nupkg
	# entirely (FilesSnapshot showed only chocolateyInstall.ps1 under tools/) -- same root
	# cause already fixed for osfmount/freeplane/searchmyfiles this way.
	$Latest.FileName32 = 'pinginfoview.zip'

	return $Latest
}

update -ChecksumFor none -NoCheckChocoVersion
