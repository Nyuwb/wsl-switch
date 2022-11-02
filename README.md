# WSL Switch

Allows you to switch the activation of certain services from one WSL instance to another.

The following services are managed :

- apache
- mysql
- php

## Requirements

You need to install the Powershell-YAML module to get this app to work.
We don't need to install it globally so we're using the `CurrentUser` scope.

```
Install-Module Powershell-YAML -Scope CurrentUser
```

## Installation

### With Scoop

### TODO

Clone this repository : `git clone https://github.com/Nyuwb/wsl-switch`

Then edit the content of the `config.yaml` file to adapt to your configuration.

By default for the `instances`, we're using the same value as the hostname, but the `key` can be the word you wants.

The `hostname` parameter should be the name of the distribution name on WSL.

Then, you'll need to execute the `installer.ps1` file to generate all the aliases and to make the configuration working.
After that, you'll need to include your `$Profile` file as he will store all aliases and functions for this application.

```
path_to\wsl-switch\config\installer.ps1
. $Profile
```

## Run

To enable the service `$service` on `hostname`, you'll need to type the following command :

```
switch-wsl $service $hostname
```

The `$hostname` parameter is the `key` stored in the `config.yaml`.

To make it easier to use, a list of aliases are created and is available below.

## Alias list

Because of Powershell, we cannot create easy aliases like with Bash (Powershell don't accept arguments).

- switch-apache : `switch-wsl apache`
- switch-mysql : `switch-wsl mysql`
- switch-php : `switch-wsl php`
- switch-apache-mysql : `switch-wsl apache,mysql`
- switch-apache-php : `switch-wsl apache,php`
- switch-mysql-php : `switch-wsl mysql,php`
- switch-all : `switch-wsl apache,mysql,php`

Every alias is linked to a function stored in your Powershell profile in : `$Profile`.  
