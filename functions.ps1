# Exécution d'une commande
Function ExecuteCommand 
{
	Param (
       [Parameter(Mandatory)] [String] $Hostname,
	   [Parameter(Mandatory)] [String] $Service,
	   [Parameter(Mandatory)] [String] $Action
    )

	# Exécution de la commande
	wsl -d $Hostname sudo service $Service $Action 2>&1 | Out-Null
	# Traitement du status
	if ( $? ) {
		WriteOutputColor ('Le service '+ $Service +' a bien été '+ $(If ($Action -eq 'stop') { 'stoppé' } else { 'démarré' })) -Color 'Green'
	} Else {
		WriteOutputColor ($(If ($Action -eq 'stop') { 'L''arrêt' } else { 'Le démarrage' }) +' du service '+ $Service +' a rencontré une erreur') -Color 'Red'
	}
}

# Sortie standard colorisée
Function WriteOutputColor {
	Param (
		[Parameter(Mandatory)] [String] $Message,
		[Parameter(Mandatory)] [String] $Color
	)
	$DefaultColor = $Host.UI.RawUI.ForegroundColor

	# Envoi du message
	$Host.UI.RawUI.ForegroundColor = $Color
	Write-Output ('Le service '+ $Service +' a bien été '+ $(If ($Action -eq 'stop') { 'stoppé' } else { 'démarré' }))
	$Host.UI.RawUI.ForegroundColor = $DefaultColor
}