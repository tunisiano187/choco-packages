$ErrorActionPreference = 'Stop' # stop on all errors

$url          = 'https://cachev2-ams02.cdn.yandex.net/download.cdn.yandex.net/browser/int/24_6_2_787_60490/en/Yandex.exe'
$checksum     = 'a4e04a38255f79950d80920ae95c4f18de58924b434fc855e1657d6fefe7d2b1'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Yandex-browser*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum      = $checksum
  checksumType  = $checksumType

  silentArgs    = "--silent"
  validExitCodes= @(0,1,3) #please insert other valid exit codes here
}

Install-ChocolateyPackage @packageArgs
