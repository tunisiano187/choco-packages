# Robust hashcat directory detection with error handling
$hashcatDir = Get-ChildItem "$env:ChocolateyToolsLocation\hashcat*" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $hashcatDir) {
  Write-Error "hashcat installation directory not found in $env:ChocolateyToolsLocation"
  exit 1
}

Push-Location $hashcatDir.FullName

try {
  $argumentsString = $args -join ' '

  if([Environment]::Is64BitProcess) {
    & ".\hashcat64.exe" @args
  } else {
    & ".\hashcat32.exe" @args
  }
} catch {
  Write-Error "Error running hashcat: $_"
  exit 1
} finally {
  Pop-Location
}
