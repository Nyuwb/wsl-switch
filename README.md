[![License](https://img.shields.io/badge/license-Apache2.0-orange.svg?style=flat-square)](LICENSE)

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

```
scoop bucket add srsrns https://github.com/mbl-35/scoop-srsrns
scoop install wsl-switch
```

To uninstall it, simply use `scoop uninstall wsl-switch`

### From GitHub

Clone this repository: `git clone https://github.com/Nyuwb/wsl-switch`

Build the app to create the `wsl-switch.ps1` single file:

```
_path_to_repository_\app.ps1 build
```

<sub>We're doing this to avoid the limitation of `Using module` in Powershell</sub>

After that, add the path to the builded file in your Powershell profile:

```
Invoke-Item $Profile
# Set-Alias wsl-switch _path_to_repository_\wsl-switch.ps1
```

## Edit the configuration file

You need to run the following command to edit the configuration file.

```
wsl-switch config
```

It will open the `config.json` file that you can edit.  
Save it, and it will direcly be used by the application.

## Run the application

To enable the service `$service` on `$hostname`, you'll need to type the following command:

```
wsl-switch $service $hostname
```

The `$hostname` parameter is the `key` stored in the `config.json`.

## Tips: How to install multiple instances

To install multiple WSL instances easier, you can use [WSLCTL](https://github.com/mbl-35/wslctl).  
It provides a single command to create, backup and manage WSL instances.