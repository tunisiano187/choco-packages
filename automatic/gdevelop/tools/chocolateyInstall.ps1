$packageName        = $env:ChocolateyPackageName
$installerType      = 'exe'
$silentArgs         = '/S'
$url                = 'https://github.com/4ian/GDevelop/releases/download/v5.6.259/GDevelop-5-Setup-5.6.259.exe'
$checksum           = 'b93519877a4676cff2b552f82b78b4e42ac152555cd5edb0597f659f08f933e5'
$checksumType       = 'sha256'
$validExitCodes     = @(0)

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"
