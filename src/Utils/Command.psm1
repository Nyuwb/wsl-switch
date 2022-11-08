Using Module '.\Console.psm1'
Using Module '..\Entity\Instance.psm1'
Using Module '..\Entity\Service.psm1'

Class Command
{
	[Void] Static Start([String] $Hostname, [Service] $Service)
	{
		# Execution of the command
		wsl -d $Hostname sudo service $Service.GetProcess() start 2>&1 | Out-Null
		# Checking the command status
		if ( $? ) {
			[Console]::WriteSuccess('The service '+ $Service.GetName() +' has been started')
		} Else {
			[Console]::WriteError('Starting the service '+ $Service.GetName() +' has encountered an error')
		}
	}

	[Void] Static Stop([String] $Hostname, [Service] $Service)
	{
		# Execution of the command
		wsl -d $Hostname sudo service $Service.GetProcess() stop 2>&1 | Out-Null
		# Checking the command status
		if ( $? ) {
			[Console]::WriteSuccess('The service '+ $Service.GetName() +' has been stopped')
		} Else {
			[Console]::WriteError('Stopping the service '+ $Service.GetName() +' has encountered an error')
		}
	}

	[Boolean] Static IsRunning([Instance] $Instance, [String] $ServiceName)
	{
		# Execution of the command
		$Status = wsl -d $Instance.GetHostname() sudo service $Instance.GetService($ServiceName).GetProcess() status 2>&1
		if ($? -And $Status -NotMatch 'is not running' -And $status -NotMatch 'is stopped') {
			Return $True
		}
		Return $False
	}
}