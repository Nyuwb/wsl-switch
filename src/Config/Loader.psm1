Using Module '..\Controller\ConfigController.psm1'
Using Module '..\Entity\Instance.psm1'
Using Module '..\Utils\Console.psm1'

Class Loader
{
	[Hashtable] $Instances = @{}
	[Array] $Services
	[String] $Path

	Loader()
	{
		# Get the root path
		$This.Path = $Env:RootPath +'\config.json'
		# Load of the configuration
		$Config = Get-Content $This.Path -Raw | ConvertFrom-JSON
		# Saving the configuration in the current class
		$This.Services = $Config.Services
		$This.SetInstances($Config.Instances)
	}

	# Checking if an instance name exists
	[Boolean] InstanceExists([String] $InstanceName)
	{
		Return ($This.GetInstances().Keys -Contains $InstanceName)
	}

	[Instance] GetByInstanceName([String] $InstanceName)
	{
		Return $This.GetInstances()[$InstanceName]
	}

	[System.Collections.ArrayList] GetOtherInstancesThan([String] $InstanceName)
	{
		$InstanceList = [System.Collections.ArrayList]::New()
		$This.GetInstances().Keys | Foreach-Object {
			If ($_ -ne $InstanceName) {
				$InstanceList.Add($This.GetByInstanceName($_))
			}
		}
		Return $InstanceList
	}

	# Associate every service together to generate a string that will be used as a regex for the command
	[String] FormatServicesToString()
	{
		$ServiceList = New-Object System.Collections.ArrayList
		$ServiceList.Add($This.Services -Join '|')
		For ($i = 0; $i -lt $This.Services.Length; $i++) {
			for ($j = 0; $j -lt $This.Services.Length; $j++) {
				if ($This.Services[$i] -ne $This.Services[$j]) {
					$ServiceList.Add($This.Services[$i] +','+ $This.Services[$j])
				}
			}
			$ServiceList.Add($This.Services -Join ',')
			# Permuting elements in array...
			$This.Services = $This.Services[1..($This.Services.Length - 1)] + $This.Services[0]
		}
		$ServicesArray = $ServiceList.ToArray() | Select -Unique
		Return ($ServicesArray -Join '|')
	}
	
	# Setter list
	[Void] SetInstances($InstanceList)
	{
		$InstanceList.PSObject.Properties | Foreach-Object {
			$Instance = [Instance]::New($_.Name, $_.Value.Hostname, $_.Value.Services)
			$This.Instances[$_.Name] = $Instance
		}
	}

	# Getter list
	[Hashtable] GetInstances()
	{
		Return $This.Instances
	}

	[System.Object] GetServices()
	{
		Return $This.Services
	}

	[String] GetVersion()
	{
		Return $This.Version
	}
}