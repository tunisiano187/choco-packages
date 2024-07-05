# Define $env:ChocolateyChecksumType from chocolateyInstall file
choco new test --outputdirectory $env:TEMP\Chocolatey\
$fichier = "$env:TEMP\Chocolatey\test\tools\chocolateyInstall.ps1"

# Read file content
$contenu = Get-Content $fichier -Raw

# Define the regex filter
$pattern = "checksumType\s*=\s*'([^']*)'"

# Find the checksumType
if ($contenu -match $pattern) {
    $checksumType = $Matches[1]
    # Set to $env:ChocolateyChecksumType
    $env:ChocolateyChecksumType = $checksumType
} else {
    Write-Output "Hash type not found set it to default."
    $env:ChocolateyChecksumType = "SHA512"
}

Write-Output "Hash type is $env:ChocolateyChecksumType."