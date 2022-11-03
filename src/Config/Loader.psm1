Using Module '..\Controller\ConfigController.psm1'
Using Module '..\Entity\Instance.psm1'
Using Module '..\Utils\Console.psm1'

Class Loader
{
	[Hashtable] $Instances = @{}
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
		$ServiceList = New-Object System.Collections.Generic.List[System.Object]
		For ($i = 0; $i -lt $This.Services.Length; $i++) {
			$ServiceList.Add($This.Services[$i])
			# Getting associated service list
			If ($i -ne $This.Services.Length -1) {
				$SubServiceList = New-Object System.Collections.Generic.List[System.Object]
				$SubServiceList.Add($This.Services[$i])
				For ($j = ($i + 1); $j -lt $This.Services.Length; $j++) {
					$ServiceList.Add($This.Services[$i] +','+ $This.Services[$j])
					$SubServiceList.Add($This.Services[$j])
				}
				$ServiceList.Add($SubServiceList.ToArray() -Join ',')
			}
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