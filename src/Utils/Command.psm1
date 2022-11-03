Using Module '.\Console.psm1'
Using Module '..\Entity\Service.psm1'

Class Command
{
	[Void] Static Execute([String] $Hostname, [Service] $Service, [String] $Action)
	{
		# Execution of the command
		wsl -d $Hostname sudo service $Service.GetProcess() $Action 2>&1 | Out-Null
		# Checking the command status
		if ( $? ) {
			[Console]::WriteSuccess('The service '+ $Service.GetName() +' has been '+ $(If ($Action -eq 'stop') { 'stopped' } else { 'started' }))
		} Else {
			[Console]::WriteError($(If ($Action -eq 'stop') { 'Stopping' } else { 'Starting' }) +' the service '+ $Service +' has encountered an error')
		}
	}
}