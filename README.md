# WSL Switch

Permet de switch l'activation de certains services d'une instance WSL à une autre.

Afin de faciliter son exécution, stockez l'ensemble dans `%USERPROFILE%\home\scripts\wsl-switch\`.

Les services suivants sont gérés :

- apache
- mysql
- php

Il est nécessaire, de modifier le contneu du fichier `config.ps1` afin que cela corresponde

Ensuite, pour la première initialisation, il vous faudra exécuter le fichier `init.ps1` afin de générer la liste des alias et de créer l'alias principal. 
En effet, Powershell ne permet pas de créer des alias avec des paramètres.

Ensuite, il faudra inclure ce fichier de profil dans Powershell afin que les alias soient reconnus :

```
$env:USERPROFILE\home\scripts\wsl-switch\init.ps1
. $Profile
```

Les alias suivants seront créés :

- switch-apache : `switch-wsl apache`
- switch-mysql : `switch-wsl mysql`
- switch-php : `switch-wsl php`
- switch-apache-mysql : `switch-wsl apache,mysql`
- switch-apache-php : `switch-wsl apache,php`
- switch-mysql-php : `switch-wsl mysql,php`
- switch-all : `switch-wsl apache,mysql,php`

Ces fonctions seront sauvegardés dans votre profil Powershell `$PROFILE`.  
Ensuite, il vous suffira d'appeler le script comme suit :

```
switch-wsl $service $hostname
```

Cela activera les services sur le nom d'hôte précisé et les désactivera sur l'autre hôte.