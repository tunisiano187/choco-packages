import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1

$releases = 'https://www.any-video-converter.com/avc-free.exe'


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

	# Root cause of the Aug 2026 "Checksum ... did not meet ..." verification failure: this
	# rolling download URL serves a fresh vendor build with no usable version metadata --
	# confirmed live, the installer's version resource has no FileVersion/ProductVersion string
	# at all in the current build -- while three separate downloads (the originally-failed
	# checksum, the one currently committed here, and a fresh one just now) each had a DIFFERENT
	# SHA256. The old FileVersionInfo-based detection below never noticed any of those changes,
	# so the committed checksum goes stale every time the vendor rotates the binary and AU never
	# re-pushes. Same technique already used for windjview/cports/projectlibre.install in this
	# repo: keep a fixed base version (the vendor's last known real release number) and only bump
	# a Last-Modified-date suffix when the freshly-downloaded checksum differs from what's already
	# committed.
	. ..\..\scripts\Get-FileVersion.ps1
	$FileVersion = Get-FileVersion -url $url32 -checksumType 'sha256'

	$version = '9.0.0'
	$installContent = Get-Content "$PSScriptRoot\tools\chocolateyInstall.ps1" -Raw
	$current_checksum = [regex]::Match($installContent, "\`$checksum\s*=\s*'([a-fA-F0-9]+)'").Groups[1].Value
	if ($current_checksum -and $current_checksum -ne $FileVersion.Checksum) {
		try {
			$lastModified = (Invoke-WebRequest -Uri $url32 -Method Head -UseBasicParsing).Headers['Last-Modified']
			$dateStamp = ([datetime]::Parse($lastModified)).ToString('yyyyMMdd')
		} catch {
			$dateStamp = Get-Date -Format 'yyyyMMdd'
		}
		$version = "$version.$dateStamp"
	}

	return @{ URL32 = $url32; Version = $version; Checksum32 = $FileVersion.Checksum; ChecksumType32 = $FileVersion.ChecksumType }
}

# 2026-09-28: -NoCheckChocoVersion removed -- v9.0.6 is confirmed live and approved on
# chocolatey.org (the nuspec here is still stuck at 0.0 since this package's push never commits
# the version back to git, the same gap documented for cports/projectlibre.install; per CLAUDE.md's
# 2026-09-05 amendment, a confirmed successful publish is enough to remove the flag even while the
# local nuspec doesn't show it).
update -ChecksumFor none
