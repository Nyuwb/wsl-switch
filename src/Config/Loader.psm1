Import-Module Powershell-Yaml

Class Loader
{
	[System.Object] $Instances
	[String] $ProjectPath

	Loader()
	{
		# Load of the configuration
		$Config = Get-Content ($PSScriptRoot +'\..\..\config.yaml') | ConvertFrom-YAML
		$This.Instances = $Config.Instances
		$This.ProjectPath = $Config.Path
	}

	GetInstances()
	{

	}
}