import-module Chocolatey-AU
Import-Module ..\..\scripts\au_extensions.psm1
import-module "$PSScriptRoot/../../scripts/au_extensions.psm1"

$releases = 'https://download.mediathekview.de/stabil/'

function global:au_BeforeUpdate($Package) {
  $licenseFile = "$PSScriptRoot\legal\LICENSE.txt"
  if (Test-Path $licenseFile) { Remove-Item -Force $licenseFile }

  Invoke-WebRequest -UseBasicParsing -Uri $($Package.nuspecXml.package.metadata.licenseUrl -replace 'blob', 'raw') -OutFile $licenseFile

  Get-RemoteFiles -Purge -NoSuffix
}
function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt"      = @{
      "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(\s*1\..+)\<.*\>"              = "`${1}<$($Latest.URL64)>"
      "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType64)"
      "(?i)(^\s*checksum(64)?\:).*"       = "`${1} $($Latest.Checksum64)"
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsPath\\).*" = "`${1}$($Latest.FileName64)`""
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'MediathekView\-[\d\.]+.*\.zip$'
  $url64 = $download_page.Links | Where-Object href -match $re | Select-Object -last 1 -expand href | ForEach-Object {
    if (!$_.StartsWith("http")) {
      [uri]::new($releases, [string]$_)
    } else {
      $_
    }
  }

  $version64 = [regex]::Match($url64, 'MediathekView-([\d.]+)-win(?:64)?\.zip$').Groups[1].Value
  if (-not $version64) {
    throw "Could not extract a version number from matched URL: $url64"
  }

  # A since-retired exe-based MediathekView definition in another repo squatted the
  # bare 15.0.0 version slot in chocolatey.org's moderation queue (NuGet package
  # IDs are case-insensitive, so both repos were competing for the same package).
  # chocolatey.org refuses to push a version string that's already claimed, approved
  # or not, so a bare X.Y.Z version can collide with that queue entry forever.
  # Appending the upstream zip's own Last-Modified date as a 4th version component
  # makes every real release unique and avoids relying on anyone clearing that queue
  # entry; it stays stable across daily runs since it only changes when upstream
  # actually re-uploads the file.
  $lastModified = (Invoke-WebRequest -Uri $url64 -Method Head -UseBasicParsing).Headers['Last-Modified']
  $dateStamp = ([datetime]::Parse($lastModified)).ToString('yyyyMMdd')

  @{
    URL64       = [uri]$url64
    Version     = [version]"$version64.$dateStamp"
    PackageName = 'MediathekView'
  }
}

update -ChecksumFor none -NoCheckUrl
