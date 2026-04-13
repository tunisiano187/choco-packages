# replaced by (Get-ChildItem "$env:ChocolateyToolsLocation\hashcat*" -Directory).FullName during installation
$hashcatDir = '{{HASHCAT_DIR}}'

# Validate directory exists (install might have failed)
if (-not (Test-Path $hashcatDir -PathType Container)) {
  Write-Error "hashcat directory not found at: $hashcatDir"
  exit 1
}

Push-Location $hashcatDir

try {
  $argumentsString = $args -join ' '                          # Join arguments to a string

  & ".\hashcat.exe" $argumentsString                          # Use & operator instead of Invoke-Expression
} catch {
  Write-Error "Error running hashcat: $_"
  exit 1
} finally {
  Pop-Location
}
