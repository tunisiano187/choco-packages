$ErrorActionPreference = 'Stop';


$packageName      = $env:ChocolateyPackageName
$url              = 'https://aka.ms/downloadmee-desktopApp'
$checksum         = 'DF1E49C10839FFDD522A76D98CDA185F4E351E5575ABEEC639A73667CA263CF1C2F2A4741371A2CF6AF069C98A4F7D08E07FFA6577ED0D5C3EF553C60AB65DEC'
$checksumType     = 'SHA512'

$packageArgs = @{
  packageName     = $packageName
  fileType        = 'exe'
  url             = $url

  silentArgs      = "/qn"
  validExitCodes  = @(0, 1603, 3010, 1641, 1622)

  softwareName    = "$packageName*"
  checksum        = $checksum
  checksumType    = $checksumType
}

  Install-ChocolateyPackage @packageArgs
