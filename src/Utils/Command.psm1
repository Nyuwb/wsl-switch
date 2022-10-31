Using Module '.\Console.psm1'

Class Command
{
	Static Execute($Hostname, $Service, $Action)
	{
		# Execution of the command
		wsl -d $Hostname sudo service $Service $Action 2>&1 | Out-Null
		# Checking the command status
		if ( $? ) {
			[Console]::WriteSuccess('The service '+ $Service +' has been '+ $(If ($Action -eq 'stop') { 'stopped' } else { 'started' }))
		} Else {
			[Console]::WriteError($(If ($Action -eq 'stop') { 'Stopping' } else { 'Starting' }) +' the service '+ $Service +' has encountered an error')
		}
	}
}