$ErrorActionPreference = 'Stop'
$packageName    = 'winflector'
$softwareName   = 'Winflector*'
$installerType  = 'EXE'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://www.winflector.com/store/free-version/index/id/535'
$checksum       = 'E8B0D41A1539CA825FE8CC4A8C805DC61806B5FD345B78D04D0BC3C4B4E566DEE5D070643B40DAC9F8E64A7AB407605D8B027416644C38723CA03CD5DA6F071D'
$checksumType   = 'SHA512'
$silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
$validExitCodes = @(0, 3010, 1641)
$ahkExe         = 'AutoHotKey'
$ahkFile        = Join-Path $toolsDir "WinflectorInstall.ahk"

$packageArgs = @{
  packageName   = $packageName
  url           = $url
  FileFullPath  = "$toolsDir\winflector.exe"
  checksum      = $checksum
  checksumType  = $checksumType
}

Get-ChocolateyWebFile @packageArgs

Start-Process $ahkExe $ahkFile

$packageArgs = @{
  packageName   = $packageName
  fileType      = $installerType
  file          = "$toolsDir\winflector.exe"
  validExitCodes= $validExitCodes
  silentArgs    = $silentArgs
  softwareName  = $softwareName
}

Install-ChocolateyInstallPackage @packageArgs
