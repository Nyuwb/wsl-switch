Using Module '..\Config\Loader.psm1'
Using Module '..\Utils\Command.psm1'

Class ServiceController
{
	[Void] Static Execute([Loader] $Config, [String] $Hostname, [String] $ServiceList)
	{
		# Getting instance list config (which should be activated and deactivated)
		$InstanceList = @{
			'Start' = $Config.GetByInstanceName($Hostname)
			'Stop' = $Config.GetOtherInstancesThan($Hostname)
		}

		# Execution of the WSL commands
		'Stop', 'Start' | Foreach-Object {
			$Action = $_
			$InstanceList[$Action] | Foreach-Object {
				$Instance = $_
				[Console]::Write($(If ($Action -eq 'Stop') { 'Dea' } else { 'A' }) +'ctivation of the services on the instance '+ $Instance.GetHostname() +"...`n")
				$ServiceList -Split ',' | ForEach-Object {
					$Service = $_
					[Command]::$Action($Instance.GetHostname(), $Instance.GetService($Service))
				}
			}
		}
	}

	[Void] Static ShowStatus([Loader] $Config)
	{
		# Getting instance list
		$InstanceList = $Config.GetInstances()

		# Getting service list
		$ServiceList = $Config.GetServices()

		# TODO
	}
}