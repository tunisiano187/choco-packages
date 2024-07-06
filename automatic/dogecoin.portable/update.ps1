$ErrorActionPreference = 'Stop'
import-module au

$releases = "https://github.com/dogecoin/dogecoin/releases/latest"
$Owner = $releases.Split('/') | Select-Object -Last 1 -Skip 3
$repo = $releases.Split('/') | Select-Object -Last 1 -Skip 2

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"            = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_AfterUpdate($Package) {
	Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
    $tags = Get-GitHubRelease -OwnerName $Owner -RepositoryName $repo -Latest
    $urls = $tags.assets.browser_download_url | Where-Object {$_ -match ".zip$"}
    $url32 = $urls | Where-Object {$_ -match 'win32'}
	$url64 = $urls | Where-Object {$_ -match 'win64'}
	$version = $url32 -split 'v|/' | select-object -Last 1 -Skip 1
    Update-Metadata -key "releaseNotes" -value $tags.html_url

	$Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
