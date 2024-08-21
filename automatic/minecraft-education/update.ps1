$ErrorActionPreference = 'Stop'
import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1

$release = 'https://aka.ms/downloadmee-desktopApp'

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
	. ..\..\scripts\Get-FileVersion.ps1
	$FileVersion = Get-FileVersion -url $release


	$Latest = @{ URL32 = $release; Version = $FileVersion.Version; Checksum32 = $FileVersion.Checksum; ChecksumType32 = $FileVersion.checksumType }
	return $Latest
}

update -ChecksumFor none -NoCheckChocoVersion