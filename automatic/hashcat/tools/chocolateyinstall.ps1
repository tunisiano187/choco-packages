$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = "$(Get-ToolsLocation)"

$file       = (Get-ChildItem -Path $toolsDir -Filter "*.7z").FullName

$packageArgs = @{
    packageName     = $env:ChocolateyPackageName
    unzipLocation   = $installDir

    File            = $file
}

Install-ChocolateyZipPackage @packageArgs


$psfile     = Join-Path "$toolsDir" "hashcat.ps1"

# resolve installation Path during installation Where-Object admin user has access the
# $env:ChocolateyToolsLocation variable
$hashcatDir = (Get-ChildItem "$env:ChocolateyToolsLocation\hashcat*" -Directory).FullName
# Insert installation path into Powershell-Script
(Get-Content $psfile -Raw).Replace('{{HASHCAT_DIR}}', $hashcatDir) | Set-Content $psfile

# Install-ChocolateyPowershellCommand's generated shim always invokes
# `powershell -Command "& '<script>' %*"` (confirmed in choco's own helper source) -- `-Command`
# parses its whole argument as one PowerShell code string, so a quoted path with spaces
# (e.g. `hashcat -m 1400 -a 0 hash.txt "C:\Users\My Name\wordlist.txt"`) loses its quoting before
# hashcat.ps1 ever sees it, and hashcat then reports "No such file or directory" on the split
# path. Shimming straight to powershell.exe with `-File` instead makes it parse everything after
# as a plain argument list, so quoted paths survive -- this is the actual fix, not just the
# `@args` splatting in hashcat.ps1 (that alone does nothing if the args already arrived mangled).
$binFileArgs = @{
    Name    = "hashcat"
    Path    = Join-Path "$env:SystemRoot" "System32\WindowsPowerShell\v1.0\powershell.exe"
    Command = "-NoProfile -ExecutionPolicy Bypass -File `"$psfile`""
}
Install-BinFile @binFileArgs
