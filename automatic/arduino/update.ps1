$ErrorActionPreference = 'Stop'
import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1

# arduino.cc's own /en/software page used to link straight to the versioned installer
# (arduino-ide_<version>_Windows_64bit.exe), which the old scraper below relied on -- it now
# only exposes the legacy Arduino IDE 1.8.19 installer and an unrelated PLC IDE installer in the
# static HTML; the modern Arduino IDE 2.x download links are rendered client-side and never
# appear in the page source AU sees. That's why this package has been stuck on 2.3.1 since
# (confirmed live: the old $url32 match picked up the 1.8.19 .exe, whose filename has no
# underscore, so the old `-split '_'` version parse silently produced an empty string --
# choco-packages#79 asks for the now-current 2.3.10). GitHub Releases is the same source
# arduino-ide's own CI publishes to and is far more reliable to scrape than the marketing page.
$releases = 'https://github.com/arduino/arduino-ide/releases/latest'
$Owner = $releases.Split('/') | Select-Object -Last 1 -Skip 3
$repo = $releases.Split('/') | Select-Object -Last 1 -Skip 2

function global:au_SearchReplace {
	@{
		'tools/chocolateyInstall.ps1' = @{
			"(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
			"(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
			"(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
		}
	}
}

function global:au_AfterUpdate($Package) {
	Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
	$tags = Get-GitHubRelease -OwnerName $Owner -RepositoryName $repo -Latest
	$url32 = $tags.assets.browser_download_url | Where-Object {$_ -match 'Windows_64bit\.exe$'} | Select-Object -First 1
	if (-not $url32) { throw "Could not find a Windows_64bit.exe asset in the latest arduino-ide release" }
	Update-Metadata -key "releaseNotes" -value $tags.html_url

	$version = $tags.tag_name.Replace('v', '')

	$Latest = @{ URL32 = $url32; Version = $version }
	return $Latest
}

update -ChecksumFor 32
