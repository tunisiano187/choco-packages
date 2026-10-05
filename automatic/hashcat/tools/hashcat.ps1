# replaced by (Get-ChildItem "$env:ChocolateyToolsLocation\hashcat*" -Directory).FullName during installation
$hashcatDir = '{{HASHCAT_DIR}}'

# Validate directory exists (install might have failed)
if (-not (Test-Path $hashcatDir -PathType Container)) {
  Write-Error "hashcat directory not found at: $hashcatDir"
  exit 1
}

Push-Location $hashcatDir

try {
  # Splat the original $args array instead of joining it into one string: joining destroys the
  # boundaries of any space-separated, quoted path (e.g. "C:\Users\My Name\wordlist.txt") before
  # hashcat.exe ever sees it, which hashcat then reports as "No such file or directory".
  & ".\hashcat.exe" @args
} catch {
  Write-Error "Error running hashcat: $_"
  exit 1
} finally {
  Pop-Location
}
