$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = "$(Get-ToolsLocation)"

$file       = (Get-ChildItem -Path $toolsDir -Filter "*.7z").FullName

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    unzipLocation   = $installDir

    File            = $file
}

Install-ChocolateyZipPackage @packageArgs


$psfile     = Join-Path "$toolsDir" "hashcat.ps1"

# resolve installation Path during installation Where-Object admin user has access the
# $env:ChocolateyToolsLocation variable
$hashcatDir = (Get-ChildItem "$env:ChocolateyToolsLocation\hashcat*" -Directory).FullName
# Insert installation path into Powershell-Script
(Get-Content $psfile -Raw).Replace('{{HASHCAT_DIR}}', $hashcatDir) | Set-Content $psfile

Install-ChocolateyPowershellCommand -PackageName "hashcat" -PSFileFullPath "$psfile"
