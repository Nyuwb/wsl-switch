Using Module '..\Config\Loader.psm1'
Using Module '..\Utils\Command.psm1'

Class ServiceController
{
	[Void] Static Call([Loader] $Config, [String] $Hostname, [String] $ServiceList)
	{
		# Getting instance list config (which should be activated and deactivated)
		$InstanceList = @{
			'start' = $Config.GetByInstanceName($Hostname)
			'stop' = $Config.GetOtherInstancesThan($Hostname)
		}

		# Execution of the WSL commands
		'stop', 'start' | Foreach-Object {
			$Action = $_
			$InstanceList[$Action] | Foreach-Object {
				$Instance = $_
				[Console]::Write($(If ($Action -eq 'stop') { 'Dea' } else { 'A' }) +'ctivation of the services on the instance '+ $Instance.GetHostname() +"...`n")
				$ServiceList -Split ',' | ForEach-Object {
					$Service = $_
					[Command]::Execute($Instance.GetHostname(), $Instance.GetService($Service), $Action)
				}
			}
		}
	}
}