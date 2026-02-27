import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1

# Use GitHub releases instead of scraping the JS-rendered Arduino website
$releasesApi = 'https://api.github.com/repos/arduino/arduino-ide/releases/latest'
$Owner = 'arduino'
$repo = 'arduino-ide'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_GetLatest {
    Write-Output "Fetching latest release from GitHub API"
    $tags = Get-GitHubRelease -OwnerName $Owner -RepositoryName $repo -Latest
    if (-not $tags) { throw "Unable to fetch GitHub release for $Owner/$repo" }

    # prefer installer exe x64
    $asset = $tags.assets | Where-Object { $_.name -match 'Windows' -or $_.name -match 'win' -or $_.name -match '\.exe$' } | Select-Object -First 1
    if (-not $asset) {
        # fallback to any exe or zip
        $asset = $tags.assets | Where-Object { $_.name -match '\.exe$|\.zip$' } | Select-Object -First 1
    }

    $url32 = $asset.browser_download_url
    . ..\..\scripts\Get-FileVersion.ps1
    $FileVersion = Get-FileVersion $url32

    $version = $tags.tag_name.Replace('v','')
    Update-Metadata -key "releaseNotes" -value $tags.html_url
    Update-Metadata -key "licenseUrl" -value ((Get-GitHubLicense -OwnerName $Owner -RepositoryName $repo).download_url)

    return @{ URL32 = $url32; Checksum32 = $FileVersion.Checksum; ChecksumType32 = $FileVersion.ChecksumType; Version = $version }
}

# Run au update
try {
    update -ChecksumFor none
} catch {
    Write-Error $_
    throw $_
}
