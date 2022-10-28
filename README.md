# WSL Switch

Permet de switch l'activation de certains services d'une instance WSL � une autre.

Afin de faciliter son ex�cution, stockez l'ensemble dans `%USERPROFILE%\home\scripts\wsl-switch\`.

Les services suivants sont g�r�s :

- apache
- mysql
- php

Il est n�cessaire, de modifier le contneu du fichier `config.ps1` afin que cela corresponde

Ensuite, pour la premi�re initialisation, il vous faudra ex�cuter le fichier `init.ps1` afin de g�n�rer la liste des alias et de cr�er l'alias principal. 
En effet, Powershell ne permet pas de cr�er des alias avec des param�tres.

Ensuite, il faudra inclure ce fichier de profil dans Powershell afin que les alias soient reconnus :

```
$env:USERPROFILE\home\scripts\wsl-switch\init.ps1
. $Profile
```

Les alias suivants seront cr��s :

- switch-apache : `switch-wsl apache`
- switch-mysql : `switch-wsl mysql`
- switch-php : `switch-wsl php`
- switch-apache-mysql : `switch-wsl apache,mysql`
- switch-apache-php : `switch-wsl apache,php`
- switch-mysql-php : `switch-wsl mysql,php`
- switch-all : `switch-wsl apache,mysql,php`

Ces fonctions seront sauvegard�s dans votre profil Powershell `$PROFILE`.  
Ensuite, il vous suffira d'appeler le script comme suit :

```
switch-wsl $service $hostname
```

Cela activera les services sur le nom d'h�te pr�cis� et les d�sactivera sur l'autre h�te.