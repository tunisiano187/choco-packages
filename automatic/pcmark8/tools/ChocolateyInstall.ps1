$ErrorActionPreference = 'Stop'
$packageName    = 'pcmark8'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://d1ejs5fxm96rib.cloudfront.net/PCMark8-v2-10-901.zip'
# This url comes from the redirection of https://benchmarks.ul.com/downloads/pcmark8.zip
# The script is :
# $releases = "https://benchmarks.ul.com/downloads/pcmark8.zip" // Url on the website that is always the latest
# $url=Get-RedirectedUrl $releases // redirected url (to have the file still available if there is a newer version)
$checksum       = '5ca0578bcf55671c2f8a1bcef767a88a687091099354e01901d418d4570547ba'
$checksumType   = 'sha256'
$silentArgs     = '/S'
$validExitCodes = @(0)
$fileLocation   = "$env:ChocolateyInstall\lib\pcmark8\tools\PCMark8-setup.exe"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'ZIP'
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'EXE'
  file          = $fileLocation
  silentArgs    = $silentArgs
  validExitCodes= $validExitCodes
  softwareName  = 'PCMark*'
}

Install-ChocolateyInstallPackage @packageArgs

Start-CheckandStop "FMSISvc"
