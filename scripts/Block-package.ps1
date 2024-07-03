﻿<#
.SYNOPSIS
  Remove Package from folder

.DESCRIPTION
  This script should be called by Github action on Issue editing to remove a package.

#>
function Block-Package {
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "issue")]
        [long]$issueNumber,
        [Parameter(Mandatory = $true)]
        [string]$title,
        [Parameter(Mandatory = $false)]
        [string]$Repository,
        [Parameter(Mandatory = $false)]
        [string]$actor
    )
    Write-Output $actor
    if(($actor -ne 'tunisiano187' -and $actor -ne 'github-actions[bot]') -or ($title.ToLower() -notmatch 'exclude' -and $title.ToLower() -notmatch 'remove' -and $title.ToLower() -notmatch 'block')) {
      throw "User $actor cannot run this"
    }
    $ErrorActionPreference = 'Stop';

    Write-Output "Repository : $Repository"

    git config --global user.email "helpdesk.choc@gmail.com"
    git config --global user.name "Tunisiano187"

    Install-Module -Name PowerShellForGitHub -Force
    Import-Module PowerShellForGitHub
    $secureString = ("$env:GITHUB_TOKEN" | ConvertTo-SecureString -AsPlainText -Force)
    $cred = New-Object System.Management.Automation.PSCredential "username is ignored", $secureString
    Set-GitHubAuthentication -Credential $cred
    $secureString = $null # clear this out now that it's no longer needed
    $cred = $null # clear this out now that it's no longer needed
    Set-GitHubConfiguration -DisableTelemetry

    [string]$Owner = "tunisiano187"
    [string]$Repository = "Choco-packages"

    Write-Output "number : $issueNumber"
    Write-Output "Title : $title"
    $extract = $title.Split('(')[1].split(')')[0]
    Write-Output "Extract : $extract"
    $folder = Join-Path $PSScriptRoot "../automatic/$extract"
    $foldericons = Join-Path $PSScriptRoot "../icons"
    Write-Output "Does the Folder exists ? : $(Test-Path -Path $folder)"
    if(!$title.ToLower -match "exclude") {
      Write-Output "Not an Exclude request"
    } else {
      if($(Test-Path -Path $folder)) {
        Remove-Item -Path $folder -Recurse -Force -ErrorAction Continue
        Remove-Item -Path "$foldericons/$extract.*" -ErrorAction Continue
      }
      if($title.ToLower() -match 'exclude') {
        Add-Content -Path "tools/Check/exclude.txt" -Value $extract
      }
      Update-GitHubIssue -OwnerName $Owner -RepositoryName $repository -Issue $issueNumber -State Closed
      git commit -am  "Exclude $extract
[skip ci]"
      git pull
      git push
    }
}
