$ErrorActionPreference = 'Stop'

$packageName    = 'real-netstat'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url            = 'https://netstatagent.com/files/netagent-setup.exe'
$checksum       = '92B40EB19E47186EFC49041A540A277DA3C0FA3D3BC80C596F2527E5448773782869669E42B0DFF9CD403FAFD3FC341F5AE7FF50AD5282EDB5E15BF035F7EE12'
$checksumType   = 'SHA512'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'Real NetStat*'
  checksum      = $checksum
  checksumType  = $checksumType
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
