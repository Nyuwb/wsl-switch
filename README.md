# WSL Switch

Allows you to switch the activation of certain services from one WSL instance to another.

The following services are managed :

- apache
- mysql
- php

## Requirements

```
Install-Module Powershell-YAML
```

## Configuration

Before anything else, you'll need to edit the content of the `config.yaml` file.

By default, we're using the name of two Ubuntu instances, but the `key` can be the word you wants.
The `hostname` should be the name of the distribution name on WSL.

Then, you'll need to execute the `installer.ps1` file to generate all the aliases and to make the configuration working.
After that, you'll need to include your `$Profile` file as he's now storing all aliases and functions for this application.

```
path_to\wsl-switch\config\installer.ps1
. $Profile
```

## Run

To enable the service `$service` on `hostname`, you'll need to type the following command :

```
switch-wsl $service $hostname
```

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
