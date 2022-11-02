Using Module '.\src\Config\Loader.psm1'
Using Module '.\src\Controller\AppController.psm1'
Using Module '.\src\Utils\Console.psm1'
Import-Module Powershell-Yaml

# Configuration loader
$Config = [Loader]::New()

# Starting application
[AppController]::New($Config).Run($Args)

Exit


# Checking params
$ServiceList = $Args[0] -Split ','
$ServiceList | ForEach-Object {
	If ($Config.Services -NotContains $_) {
		[Console]::WriteError('Parameter #1 (services) is invalid, the following list is available  : '+ ($Config.Services -Join ', '))
	}
}
If ($Config.GetByInstanceName($Args[1]).Services.Length -eq 0) {
	[Console]::WriteError('Parameter #2 (instance) is invalid, enter the name of the instance to activate')
	Exit
}

# Getting instance list config (which should be activated and deactivated)
$InstanceList = @{
	'start' = $Config.GetByInstanceName($Args[1])
	'stop' = $Config.GetOtherInstanceThan($Args[1])
}

# Verifying the two instances config
If ($InstanceList['start'] -eq $null -or $InstanceList['stop'] -eq $null) {
	[Console]::WriteError('The instance list configuration didn''t load properly')
}

# Execution of the WSL commands
'stop', 'start' | Foreach-Object {
	$Action = $_
	[Console]::Write($(If ($Action -eq 'stop') { 'Dea' } else { 'A' }) +'ctivation of the services on the instance '+ $InstanceList[$Action].Hostname +'...')
	$ServiceList | ForEach-Object {
		[Command]::Execute($InstanceList[$Action].Hostname, $InstanceList[$Action].Services[$_], $Action)
	}
}