﻿$packageName    = 'apktool'
$url            = 'https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar'
$checksum       = '7956eb04194300ce0d0a84ad18771eebc94b89fb8d1ddcce8ea4c056818646f4'
$checksumType   = 'sha256'
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installFile    = Join-Path $toolsDir "apktool.jar"

Get-ChocolateyWebFile -PackageName "$packageName" `
                      -FileFullPath "$installFile" `
                      -Url "$url" `
                      -Checksum "$checksum" `
                      -ChecksumType "$checksumType"

Write-Verbose "Create batch to start jar executable"
$installBat = Join-Path -Path $toolsDir `
                        -ChildPath "apktool.bat"
if (!(Test-Path $installBat)) {
Write-Verbose "Source: https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/windows/apktool.bat"
'@echo off
if "%PATH_BASE%" == "" set PATH_BASE=%PATH%
set PATH=%CD%;%PATH_BASE%;
java -jar -Duser.language=en "%~dp0\apktool.jar" %1 %2 %3 %4 %5 %6 %7 %8 %9' |
Out-File -FilePath $installBat `
         -Encoding ASCII
}
Install-BinFile -Name $packageName -Path $installBat
