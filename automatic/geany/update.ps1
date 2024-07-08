$ErrorActionPreference = 'Stop'
import-module au

$releases = 'https://api.github.com/repos/geany/geany/releases/latest'
$Owner = $releases.Split('/') | Select-Object -Last 1 -Skip 3
$repo = $releases.Split('/') | Select-Object -Last 1 -Skip 2

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
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
    $version = $tags.tag_name
    Update-Metadata -key "releaseNotes" -value $tags.html_url
	if($tags.prerelease -match "true") {
        $date = $tags.published_at.ToString("yyyyMMdd")
        $version = "$version-pre$($date)"
    }
    if($version -eq '2.0.0') {
        $version = "2.0.0.20231106"
    }

    return @{ URL32 = $url32; Version = $version }
}

update-package -ChecksumFor 32
