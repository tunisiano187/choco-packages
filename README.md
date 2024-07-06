# Chocolatey-packages

### Automatic-Updating
[![jsdelivr](https://data.jsdelivr.com/v1/package/gh/tunisiano187/Choco-packages/badge?style=rounded)](https://gitlab.com/chocolatey-packages/automatic-updating) [![CodeFactor](https://www.codefactor.io/repository/github/tunisiano187/Choco-packages/badge)](https://www.codefactor.io/repository/github/tunisiano187/Choco-packages)
[![GitHub Activity](https://img.shields.io/github/commit-activity/m/tunisiano187/Choco-packages)](https://github.com/tunisiano187/Choco-packages/commits/master)


### Description

This repository contains chocolatey packages created and maintained by [tunisiano](https://chocolatey.org/profiles/tunisiano) that are daily updated
The list of packages can be found [here](https://github.com/tunisiano187/Choco-packages/blob/master/Packages.md)

### Patreon
[![Patreon](https://cdn.jsdelivr.net/gh/tunisiano187/choco-packages@f986b7f5de3afc021180256752805698d4efbc38/icons/patreon.png)](https://www.patreon.com/tunisiano)

## Guidelines

### Reporting broken/outdated packages

If packages from this repository fail to install or a new version has been released by the software vendor for a particular package, please report it in any or all of the following ways:

Github issue: https://github.com/tunisiano187/Choco-packages/issues/new

### Broken packages

If the package fails to install or uninstall via choco, please include debug information from the console:   
```choco install PKGID --yes --verbose --debug```

### Outdated packages

If the package is not up to date, please include the following if possible:

latest version number
release date
URL to the install binary

### Contributing
1. As much as possible, these packages are [automatic](https://chocolatey.org/docs/automatic-packages) and all automatic packages will use the [Chocolatey-AU module](https://github.com/chocolatey-community/chocolatey-au/).
2. If allowed, packages will include the packaged software directly in the `.nupkg` archive instead of downloading it from another site at the time of install.  Only tools that allow redistribution in their license can be embedded and such packages must include two additional files in the `legal` directory - `VERIFICATION.txt` and `License.txt`.
3. Code is written for humans, not for computers (i.e. assembly). Make the code readable and commented, but also efficient. The goal is not to obfuscate. If another one wants to help, he needs to understand it too!
4. All the metadata attributes in the package needs to be filled up as much as possible. If a metadata tag is empty, it is because the information is not available. In case of the metadata should be publicly presented as it is important, but still not available on the net, you could need to contact the publisher of the software.

### Tags
Read this [Page](https://github.com/tunisiano187/Choco-packages/wiki/Tags.md)