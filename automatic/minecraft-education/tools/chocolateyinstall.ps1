$ErrorActionPreference = 'Stop';


$packageName      = $env:ChocolateyPackageName
$url              = 'https://downloads.minecrafteduservices.com/retailbuilds/Msi/x86/MinecraftEducation_x86_1.21.500.0.exe'
$checksum         = '615AE3BA6447AE5DEECD71659473E718AFA757DBDE1330FF645BCEC9480BD3E6B426E13BD15DFEE92BBE66EF74751758A2F76344795E419A8696021DFE9239CD'
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
