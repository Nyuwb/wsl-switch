Using Module '.\Service.psm1'

Class Instance
{
	[String] $Id
	[String] $Hostname
	[Hashtable] $Services = @{}

	Instance($Id, $Hostname, $Services)
	{	
		$This.Id = $Id
		$This.Hostname = $Hostname
		$This.SetServices($Services)
	}

	# Setter list
	[Void] SetServices($Services)
	{
		$Services.PSObject.Properties | Foreach-Object {
			$Service = [Service]::New($_.Name, $_.Value)
			$This.Services[$_.Name] = $Service
		}
	}

	# Getter list
	[String] GetId()
	{
		Return $This.Id
	}

	[String] GetHostname()
	{
		Return $This.Hostname
	}

	[System.Object] GetServices()
	{
		Return $This.Services
	}

	[System.Object] GetService($Service)
	{
		Return $This.Services[$Service]
	}
}