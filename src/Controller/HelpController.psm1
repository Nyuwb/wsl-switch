Using Module '..\Utils\Console.psm1'

Class HelpController
{
	[Void] Static Show()
	{
		[Console]::Write("Usage: wsl-switch [command] [optional arguments]`n")
		[Console]::Write("Global commands:")
		[Console]::Write("   config`t`t`tOpen the configuration file")
		[Console]::Write("   help`t`t`t`tShow this message")
		[Console]::Write("   instances`t`t`tShow the instance list")
		[Console]::Write("   services`t`t`tShow the service list")
		[Console]::Write("   status`t`t`tShow the status of each service")
		[Console]::Write("   version`t`t`tShow the application version")
		[Console]::Write("`nService switch, enable the service on the entered instance name and disable it on the other one:")
		[Console]::Write("   apache foo`t`t`tActivate apache on foo")
		[Console]::Write("   mysql bar`t`t`tActivate mysql on bar")
		[Console]::Write("   php baz`t`t`tActivate php on baz`n")
		[Console]::Write("The services can be written comma-separated to enable them together, for example:")
		[Console]::Write("   apache,php foo`t`tActivate apache and php on foo")
		[Console]::Write("   all bar`t`tActivate all services on bar`n")
	}
}