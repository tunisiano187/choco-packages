$ErrorActionPreference = 'Stop'
$packageName    = 'winflector'
$softwareName   = 'Winflector*'
$installerType  = 'EXE'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://www.winflector.com/store/free-version/index/id/528'
$checksum       = '7D892A83ED0D6E421E552540BA40ABEDAACFB184489675302A52DCC0B516680C2EAE2C74C21A6CEF9B2968CD83E7030F1A047E58ED0271D9E5CFAEFA0246D8BF'
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
