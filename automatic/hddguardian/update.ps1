$ErrorActionPreference = 'Stop'
import-module au

function global:au_SearchReplace {
	@{
		"$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
        }
	}
}

function global:au_AfterUpdate($Package) {
	Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
	$choc=$(choco search hddguardian.install | Where-Object {$_ -match "hdd"})
	$version = $choc.Split(" ")[1]

	$Latest = @{ Version = $version }
	return $Latest
}

update -ChecksumFor none
