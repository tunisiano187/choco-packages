import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1

$releases = 'https://ramensoftware.com/downloads/7tt_setup.exe'


function global:au_SearchReplace {
	@{
		'tools/chocolateyInstall.ps1' = @{
			"(^[$]url\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
			"(^[$]checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
			"(^[$]checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
		}
	}
}



function global:au_AfterUpdate($Package) {
	Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
    $url32 = $releases

	$url = "https://raw.githubusercontent.com/m417z/7-Taskbar-Tweaker/refs/heads/master/include/version.h"
	try {
		$content = Invoke-WebRequest -Uri $url -UseBasicParsing
		$content = $content.Content
	} catch {
		Write-Error "Erreur lors du téléchargement du fichier : $($_.Exception.Message)"
		exit
	}

	if ($content -match '#define VERSION_MAJOR\s+(\d+)') {
		$versionMajor = $Matches[1]
	}

	if ($content -match '#define VERSION_MINOR\s+(\d+)') {
    	$versionMinor = $Matches[1]
	}

	if ($content -match '#define VERSION_BUILD\s+(\d+)') {
    	$versionBuild = $Matches[1]
	}
	$version = "$versionMajor.$versionMinor.$versionBuild"

	
	$File = "$($env:TEMP)\7tt_setup.exe"
	Invoke-WebRequest -Uri $url32 -OutFile $File
    $version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File).FileVersion

    return @{ URL32 = $url32; Version = $version }
}

update -ChecksumFor 32
