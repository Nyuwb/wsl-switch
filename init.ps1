# Création du fichier de profile s'il n'existe pas
if (-not(Test-Path -Path $Profile)) {
	New-Item -Path $Profile -Type 'File' -Force
}

# Suppression du contenu existant, s'il existe
$Content = Get-Content -Path $Profile -Raw
$Content = $Content -Replace '(\#WSLSwitch)[\S\s]+(\#WSLSwitchEND)', ''
Set-Content -Path $Profile -Value $Content.Trim()

# Copie du contenu des alias
Add-Content -Path $Profile -Value (Get-Content $PSScriptRoot\alias-list.txt)