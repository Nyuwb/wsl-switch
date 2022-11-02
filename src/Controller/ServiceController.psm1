Class ServiceController
{
	Static Install($Config, $ConfigFile)
	{
		# Checking if the project path is reachable
		if ((Test-Path -Path $Config.ProjectPath) -eq $False) {
			[Console]::WriteError('The ProjectPath in the configuration file is not reachable')
			Exit
		}

		# Checking if the configuration file path exists, if not create it
		if ((Test-Path -Path $ConfigFile) -eq $False) {
			New-Item -Path $ConfigFile -Type 'File' -Force
		}

		# Loading the alias list
		$AliasContent = Get-Content ($Config.ProjectPath +'\config\alias-list.txt')

		# Removing the old alias-list content of the configuration file
		$Content = Get-Content -Path $ConfigFile -Raw
		If ($Content.Length -gt 0) {
			$Content = $Content -Replace '(\#WSLSwitch)[\S\s]+(\#WSLSwitchEND)', ''
			Set-Content -Path $ConfigFile -Value $Content.Trim()
		}

		# Updating the alias-list content in the profile file
		Add-Content -Path $ConfigFile -Value '#WSLSwitch'
		Add-Content -Path $ConfigFile -Value ('Set-Alias switch-wsl '+ $Config.ProjectPath +'\app.ps1')
		Add-Content -Path $ConfigFile -Value $AliasContent
		Add-Content -Path $ConfigFile -Value '#WSLSwitchEnd'
	}
}