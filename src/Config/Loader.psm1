Using Module '..\Controller\ConfigController.psm1'
Using Module '..\Utils\Console.psm1'

Class Loader
{
	[System.Object] $Instances
	[String] $ProjectPath
	[Array] $Services
	[String] $Version = '0.3'

	Loader()
	{
		# Get the root path
		$RootPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName
		# Load of the configuration
		$Config = Get-Content ($RootPath +'\config.json') -Raw | ConvertFrom-JSON
		# Saving the configuration in the current class
		$This.Services = $Config.Services
		$This.Instances = $Config.Instances
		$This.ProjectPath = $RootPath
	}

	[System.Object] GetInstances()
	{
		Return $This.Instances
	}

	[System.Object] GetByInstanceName($InstanceName)
	{
		Return $This.GetInstances()[$InstanceName]
	}

	[System.Object] GetOtherInstanceThan($InstanceName)
	{
		$Instance = $null
		$This.GetInstances().Keys | Foreach-Object {
			If ($_ -ne $InstanceName) {
				$Instance = $This.GetByInstanceName($_)
			}
		}
		Return $Instance
	}

	[String] GetVersion()
	{
		Return $This.Version
	}
}