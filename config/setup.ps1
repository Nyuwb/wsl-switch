. $PSScriptRoot\..\functions.ps1
. $PSScriptRoot\..\env.ps1

# Creation of the $Profile path if it doesn't exist
if (-not(Test-Path -Path $Profile)) {
	New-Item -Path $Profile -Type 'File' -Force
}

# Checking if the configuration is okay
if (-not(Test-Path -Path $Config.Path)) {
	WriteOutputColor 'The Path in the configuration file is not reachable' -Color Red
	Exit
}
Exit

# Updating the app path in the alias-list from the environment file
$AliasContent = Get-Content $PSScriptRoot\alias-list.txt
# TODO sed Set-Alias switch-wsl $env:USERPROFILE\home\scripts\wsl-switch\app.ps1

# Removing the old alias-list content in the $Profile file
$Content = Get-Content -Path $Profile -Raw
$Content = $Content -Replace '(\#WSLSwitch)[\S\s]+(\#WSLSwitchEND)', ''
Set-Content -Path $Profile -Value $Content.Trim()

# Updating the alias-list content in the $Profile file
Add-Content -Path $Profile -Value $AliasContent