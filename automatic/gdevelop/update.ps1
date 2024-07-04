$ErrorActionPreference = 'Stop'
import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1

$releases = 'https://api.github.com/repos/4ian/GDevelop/releases/latest'
$Owner = $releases.Split('/') | Select-Object -Last 1 -Skip 3
$repo = $releases.Split('/') | Select-Object -Last 1 -Skip 2

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
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
    $tags = Get-GitHubRelease -OwnerName $Owner -RepositoryName $repo -Latest
    $url32 = $tags.assets.browser_download_url | Where-Object {$_ -match ".exe$"}

    $version = $tags.tag_name.Replace('v','')
    Update-Metadata -key "releaseNotes" -value $tags.html_url
    Update-Metadata -key "licenseUrl" -value $((Get-GitHubLicense -OwnerName $Owner -RepositoryName $repo).download_url)
	if($tags.prerelease -match "true") {
        $date = $tags.published_at.ToString("yyyyMMdd")
        $version = "$version-pre$($date)"
    }

    return @{ URL32 = $url32; Version = $version }
}

update-package -NoCheckChocoVersion
