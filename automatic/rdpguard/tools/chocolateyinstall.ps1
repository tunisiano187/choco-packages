$ErrorActionPreference = 'Stop'
$packageName    = 'rdpguard'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://rdpguard.com/download/rdpguard-9-7-9.exe'
$checksum       = '44dea34f7fb98f01a1ed82012bee75dc054bbd4836436eb9bea58b563c15dcd3'
$checksumType   = 'sha256'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  validExitCodes= @(0)
  silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  softwareName  = 'RdpGuard*'
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyPackage @packageArgs
