# replaced by (Get-ChildItem "$env:ChocolateyToolsLocation\hashcat*" -Directory).FullName during installation
$hashcatDir = '{{HASHCAT_DIR}}'

Push-Location $hashcatDir

$argumentsString = $args -join ' '                          # Join arguments to a string

Invoke-Expression ".\hashcat.exe $argumentsString"      # Invoke executable with parameters

Pop-Location
