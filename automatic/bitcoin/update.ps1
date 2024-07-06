$ErrorActionPreference = 'Stop'
import-module au

$releases = 'https://github.com/bitcoin/bitcoin/releases/latest'
$Owner = $releases.Split('/') | Select-Object -Last 1 -Skip 3
$repo = $releases.Split('/') | Select-Object -Last 1 -Skip 2

if ($MyInvocation.InvocationName -ne '.') {
    function global:au_SearchReplace {
        @{
            "$($Latest.PackageName).nuspec" = @{
                "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
            }
        }
    }
}

function global:au_GetLatest {
    $choc=$(choco search bitcoin.install | Where-Object {$_ -match "bitcoin.install"})
	$version = $choc.Split(" ")[1]

    return @{
        Version = $version
    }
}

update -ChecksumFor none
