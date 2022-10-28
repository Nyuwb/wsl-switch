# Ex�cution d'une commande
Function ExecuteCommand 
{
	Param (
       [Parameter(Mandatory)] [String] $Hostname,
	   [Parameter(Mandatory)] [String] $Service,
	   [Parameter(Mandatory)] [String] $Action
    )

	# Ex�cution de la commande
	wsl -d $Hostname sudo service $Service $Action 2>&1 | Out-Null
	# Traitement du status
	if ( $? ) {
		WriteOutputColor ('Le service '+ $Service +' a bien �t� '+ $(If ($Action -eq 'stop') { 'stopp�' } else { 'd�marr�' })) -Color 'Green'
	} Else {
		WriteOutputColor ($(If ($Action -eq 'stop') { 'L''arr�t' } else { 'Le d�marrage' }) +' du service '+ $Service +' a rencontr� une erreur') -Color 'Red'
	}
}

# Sortie standard coloris�e
Function WriteOutputColor {
	Param (
		[Parameter(Mandatory)] [String] $Message,
		[Parameter(Mandatory)] [String] $Color
	)
	$DefaultColor = $Host.UI.RawUI.ForegroundColor

	# Envoi du message
	$Host.UI.RawUI.ForegroundColor = $Color
	Write-Output ('Le service '+ $Service +' a bien �t� '+ $(If ($Action -eq 'stop') { 'stopp�' } else { 'd�marr�' }))
	$Host.UI.RawUI.ForegroundColor = $DefaultColor
}