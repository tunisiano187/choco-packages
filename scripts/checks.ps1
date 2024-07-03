Write-Host "Checking nuspec errors"
scripts/Find-NuspecError.ps1
git commit -am "Nuspec errors"
Write-Host "updating packageSourceUrl"
scripts/Update-PackageSourceUrl.ps1 -GithubRepository "tunisiano187/Chocolatey-packages" -UseStopwatch
git commit -am "PackageSourceUrl"
Write-Host "updating variables in ps1"
scripts/Update-Variables.ps1
git commit -am "ps1 vars"
Write-Host "updating IconUrl in nuspec"
scripts/Update-IconUrl.ps1 -Quiet -GithubRepository "tunisiano187/Chocolatey-packages" -UseStopwatch
git commit -am "Updating icons"
Write-Host "updating owners in nuspec"
import-module Wormies-AU-Helpers
$nuspec=Get-ChildItem ./*.nuspec -Recurse; foreach ($file in $nuspec) { Update-Metadata -key owners -value "tunisiano" -NuspecFile $file.FullName }
git commit -am "Updating owner"
Write-Host "Updating Packages.md"
scripts/ListPackages.ps1
git commit -am "List packages"
    