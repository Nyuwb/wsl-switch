Using Module '..\Config\Loader.psm1'
Using Module '..\Utils\Console.psm1'

Class AppController
{
	[Loader] $Config

	AppController([Loader] $Config)
	{
		$This.Config = $Config
	}

	[Void] Run([String[]] $Arguments)
	{
		Try {
			# Veryfying arguments
			If ($Arguments.Length -eq 0) {
				Throw 'Missing arguments'
			}
			# Getting command from first argument
			Switch ($Arguments[0]) {
				'help' {
					# Writing the list of commands
					[Console]::Write("Usage: wsl-switch [command] [arguments]`n")
					[Console]::Write("Global commands:")
					[Console]::Write("   help`t`t`tShow this message")
					[Console]::Write("   config`t`tOpen the configuration file")
					[Console]::Write("   config-update`tUpdate the configuration file content in the application")
					[Console]::Write("`nService switch, enable the service on the entered instance name and disable it on the other one:")
					[Console]::Write("   apache foo`t`tActivate apache on foo")
					[Console]::Write("   mysql bar`t`tActivate mysql on bar")
					[Console]::Write("   php baz`t`tActivate php on baz`n")
					[Console]::Write("The services can be written comma-separated to enable them together, for example :")
					[Console]::Write("   apache,php foo`tActivate apache and php on foo`n")
				}
				'config' {
					# Opening config.yaml with the default editor
					Invoke-Item 'config.yaml'
					[Console]::Write('Opening config.yaml... after you finished, please use the command "wsl-switch config-update"')
				}
				'config-update' {
					# TODO
				}
				Default {
					Throw ('Invalid argument : '+ $Arguments[0])
				}
			}
		} Catch {
			[Console]::WriteError('Error: '+ $_)
			Exit
		}
	}
}