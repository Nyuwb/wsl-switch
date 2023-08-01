[![License](https://img.shields.io/badge/license-Apache2.0-orange.svg?style=flat-square)](LICENSE) [![Publish release on GitHub](https://github.com/Nyuwb/wsl-switch/actions/workflows/build_release.yml/badge.svg?branch=main)](https://github.com/Nyuwb/wsl-switch/actions/workflows/build_release.yml)

# WSL Switch

Allows you to switch the activation of certain services from one WSL instance to another.

The following services are currently managed, but you can custom it in the `config.json` file:

- apache
- mysql
- php

## Installation

### From Scoop

Add the bucket [scoop-srsrns](https://github.com/mbl-35/scoop-srsrns).  
Then install it directly from this bucket:

```bash
scoop bucket add srsrns https://github.com/mbl-35/scoop-srsrns
scoop install wsl-switch
```

To uninstall it, simply use `scoop uninstall wsl-switch`

### From GitHub

Download the latest build from [GitHub](https://github.com/Nyuwb/wsl-switch/releases/latest/).

Unzip it then add the path to the ps1 file in your Powershell profile:

```bash
Invoke-Item $Profile
# Set-Alias wsl-switch _path_to_repository_\wsl-switch.ps1
```

## Edit the configuration file

You need to run the following command to edit the configuration file.

```bash
wsl-switch config
```

It will open the `config.json` file that you can edit.  
Save it, and it will direcly be used by the application.

## Run the application

To enable the service `$service` on `$hostname`, you'll need to type the following command:

```bash
wsl-switch $service $hostname
```

The `$hostname` parameter is the `key` stored in the `config.json`.  
You can switch all configured services at once by using the parameter `all` instead of `$service`.

## Tips: How to install multiple instances

To install multiple WSL instances easier, you can use [WSLCTL](https://github.com/mbl-35/wslctl).  
It provides a single command to create, backup and manage WSL instances.
