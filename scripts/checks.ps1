﻿$ErrorActionPreference = "SilentlyContinue"

Write-Host "Checking nuspec errors"
scripts/Find-NuspecError.ps1
git commit -am "Nuspec errors"
Write-Host "updating packageSourceUrl"
scripts/Update-PackageSourceUrl.ps1 -GithubRepository "tunisiano187/Choco-packages" -UseStopwatch
git commit -am "PackageSourceUrl"
Write-Host "updating variables in ps1"
scripts/Update-Variables.ps1
git commit -am "ps1 vars"
Write-Host "updating IconUrl in nuspec"
scripts/Update-IconUrl.ps1 -Quiet -GithubRepository "tunisiano187/Choco-packages" -UseStopwatch
git commit -am "Updating icons"
Write-Host "updating owners in nuspec"
import-module Wormies-AU-Helpers
$nuspec=Get-ChildItem ./*.nuspec -Recurse; foreach ($file in $nuspec) { Update-Metadata -key owners -value "tunisiano" -NuspecFile $file.FullName }
git commit -am "Updating owner"
Write-Host "updating tunisiano187/chocolatey-packages to choco-packages"
$md=Get-ChildItem ./*.md -Recurse; foreach ($file in $md) { ((Get-Content $file.FullName) -replace “tunisiano187/Chocolatey-packages”, “tunisiano187/Choco-packages”) -replace 'https://cdn.jsdelivr.net/gh/tunisiano187/Chocolatey-packages@d15c4e19c709e7148588d4523ffc6dd3cd3c7e5e/icons/patreon.png', 'https://cdn.jsdelivr.net/gh/tunisiano187/choco-packages@f986b7f5de3afc021180256752805698d4efbc38/icons/patreon.png' | Set-Content -Path $file.FullName }
git commit -am "Updating repository"
Write-Host "Updating Packages.md"
scripts/ListPackages.ps1
git commit -am "List packages"
git pull
git push origin master
exit 0