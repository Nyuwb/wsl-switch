# WSL Switch

Allows you to switch the activation of certain services from one WSL instance to another.

The following services are currently managed, but you can custom it in the `config.json` file :

- apache
- mysql
- php

## Installation

### From Scoop

Add the bucket `scoop-srsrns`.
Then install it directly from this bucket :

```
scoop bucket add srsrns https://github.com/mbl-35/scoop-srsrns
scoop install wsl-switch
```

To uninstall it, simply use `scoop uninstall wsl-switch`

### From GitHub

Clone this repository : `git clone https://github.com/Nyuwb/wsl-switch`

Add the path to the local repository on your Powershell profile :

```
Invoke-Item $Profile
# Set-Alias wsl-switch _path_to_repository_\wsl-switch.ps1
```

## Edit the configuration file

You need to run the following command to edit the configuration file.

```
wsl-switch config
```

Save it, and it will direcly be used by the application.

## Run the application

To enable the service `$service` on `hostname`, you'll need to type the following command :

```
wsl-switch $service $hostname
```

The `$hostname` parameter is the `key` stored in the `config.json`.