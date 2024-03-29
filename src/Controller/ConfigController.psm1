Class ConfigController
{
	[Void] Static CheckConfigurationFile()
	{
		$ConfigFile = $Env:RootPath +'\config.json'
		# Checking if the configuration file
		if ((Test-Path -Path $ConfigFile) -eq $False) {
			Throw 'The configuration file ''config.json'' has not been found, please reinstall the application'
		}

		# Checking the content
		$Content = Get-Content $ConfigFile -Raw
		If ([ConfigController]::TestJson($Content) -eq $False) {
			Throw 'The configuration file content is not a valid JSON'
		}

		# Checking services and instances correlation
		$Content = $Content | ConvertFrom-JSON
		[ConfigController]::CheckJsonContent($Content)
	}

	[Boolean] Static TestJson([String] $Content)
	{
		$TestJson = $False
		try {
			$Content | ConvertFrom-JSON -ErrorAction Stop
			$TestJson = $True
		} catch {
			$TestJson = $False
		}
		Return $TestJson
	}

	[Void] Static CheckJsonContent($Content)
	{
		# Checking services
		$Services = $Content.Services
		If ($Services -eq $null) {
			Throw 'The services property is missing in the configuration'
		}

		# Checking instances
		$InstanceLength = 0
		$Content.Instances.PSObject.Properties | Foreach-Object {
			$InstanceLength += 1
			$InstanceName = $_.Name
			# Checking the hostname
			If ($_.Value.Hostname -eq $null) {
				Throw 'The hostname is missing for the instance '''+ $InstanceName +''''
			}
			# Checking the service list
			$InstanceServices = $_.Value.Services.PSObject.Properties.Name
			$Services | ForEach-Object {
				If ($InstanceServices -NotContains $_) {
					Throw 'The service '''+ $_ +''' doesn''t exists for the instance '''+ $InstanceName +''''
				}
			}
		}
		If ($InstanceLength -le 1) {
			Throw 'The instances property is invalid in the configuration'
		}
	}

	[Void] Static CheckWSL([Hashtable] $InstanceList)
	{
		# Checking that all instances are existing in WSL
		$InstanceList.Keys | Foreach-Object {
			$Hostname = $_.Value.Hostname
			$CheckWSL = wsl -l | Where { $_.Replace("`0", '') -Match $Hostname }
			If ($CheckWSL.Length -eq 0) {
				Throw 'The hostname ''' + $Hostname + ''' is not existing in WSL for the instance '''+ $_ +''''
			}
		}
	}
}