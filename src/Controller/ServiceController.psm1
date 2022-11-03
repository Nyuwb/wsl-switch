Using Module '..\Config\Loader.psm1'
Using Module '..\Utils\Command.psm1'

Class ServiceController
{
	[Void] Static Call([Loader] $Config, [String] $Hostname, [String] $ServiceList)
	{
		# Getting instance list config (which should be activated and deactivated)
		$InstanceList = @{
			'start' = $Config.GetByInstanceName($Hostname)
			'stop' = $Config.GetOtherInstanceThan($Hostname)
		}

		# Verifying the two instances config
		If ($InstanceList['start'].GetType() -eq $null -or $InstanceList['stop'] -eq $null) {
			Throw 'The instance list configuration didn''t load properly'
		}

		# Execution of the WSL commands
		'stop', 'start' | Foreach-Object {
			$Action = $_
			[Console]::Write($(If ($Action -eq 'stop') { 'Dea' } else { 'A' }) +'ctivation of the services on the instance '+ $InstanceList[$Action].GetHostname() +"...`n")
			$ServiceList -Split ',' | ForEach-Object {
				[Command]::Execute($InstanceList[$Action].GetHostname(), $InstanceList[$Action].GetService($_), $Action)
			}
		}
	}
}