$hashcatDir = (Get-ChildItem "$env:ChocolateyToolsLocation\hashcat*" -Directory).FullName

Push-Location $hashcatDir

$argumentsString = $args -join ' '                          # Join arguments to a string

if([Environment]::Is64BitProcess) {                         # If 64-bit
  Invoke-Expression ".\hashcat64.exe $argumentsString"      # Invoke 64-bit executable with parameters
}
else {                                                      # If not 64-bit
  Invoke-Expression ".\hashcat32.exe $argumentsString"      # Invoke 32-bit executable with parameters
}

Pop-Location