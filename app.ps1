# Inclusion des fichiers nécessaires
. $PSScriptRoot\config.ps1
. $PSScriptRoot\functions.ps1

# Configuration des services
$AppConfig = @{
	'VersionList' = '5', '7'
	'ServiceList' = 'apache', 'mysql', 'php'
}

# Vérification des paramètres transmis
$ServiceList = $Args[0] -Split ','
$ServiceList | ForEach-Object {
	If ($AppConfig.ServiceList -NotContains $_) {
		Write-Output ('Argument #1 invalide, seuls les arguments suivants sont reconnus : '+ ($AppConfig.ServiceList -Join ', '))
		Exit
	}
}
If ($Config[$args[1]].Services.Length -eq 0) {
	Write-Output ('Argument #2 invalide, veuillez saisir le nom de l''instance à activer')
	Exit
}

# Récupération de la configuration des instances
$InstanceList = @{
	'start' = $Config[$args[1]]
}
:GetOtherElement ForEach ($Hash in $Config.Keys) {
	If ($Hash -ne $args[1]) {
    	$InstanceList['stop'] = $Config[$Hash]
		Break GetOtherElement
	}
}

# Vérification de récupération des données
If ($InstanceList['stop'] -eq $null) {
	Write-Output ('Argument #2 invalide, veuillez saisir le nom de l''instance à activer')
}

# Exécution des commandes, d'abord on stoppe ensuite on start
'stop', 'start' | Foreach-Object {
	$Action = $_
	Write-Output ($(If ($Action -eq 'stop') { 'Désa' } else { 'A' }) +'ctivation des services de l''instance '+ $InstanceList[$Action].Hostname +'...')
	$ServiceList | ForEach-Object {
		ExecuteCommand -Hostname $InstanceList[$Action].Hostname -Service $InstanceList[$Action].Services[$_] -Action $Action
	}
}