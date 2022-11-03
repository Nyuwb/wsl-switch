Using Module '.\ConfigController.psm1'
Using Module '..\Config\Loader.psm1'
Using Module '..\Utils\Console.psm1'

Class AppController
{
	[Void] Static Run([String[]] $Arguments)
	{
		Try {
			# Veryfying arguments
			If ($Arguments.Length -eq 0) {
				Throw 'Missing command'
			}
			# Checking the configuration file
			[ConfigController]::CheckConfigurationFile()
			$Config = [Loader]::New()
			# Getting command from first argument
			Switch ($Arguments[0]) {
				'config' {
					# Opening config.yaml with the default editor
					[Console]::Write('Opening config.json...')
					Invoke-Item 'config.json'
				}
				'help' {
					# Writing the list of commands
					[Console]::Write("Usage: wsl-switch [command] [optionnal arguments]`n")
					[Console]::Write("Global commands:")
					[Console]::Write("   config`t`tOpen the configuration file")
					[Console]::Write("   help`t`t`tShow this message")
					[Console]::Write("   version`t`tShow the application version")
					[Console]::Write("`nService switch, enable the service on the entered instance name and disable it on the other one:")
					[Console]::Write("   apache foo`t`tActivate apache on foo")
					[Console]::Write("   mysql bar`t`tActivate mysql on bar")
					[Console]::Write("   php baz`t`tActivate php on baz`n")
					[Console]::Write("The services can be written comma-separated to enable them together, for example :")
					[Console]::Write("   apache,php foo`tActivate apache and php on foo`n")
				}
				'version' {
					[Console]::Write('wsl-switch version '+ $Config.GetVersion())
				}
				Default {
					Throw (''''+ $Arguments[0] +''' is not a valid command, please check wsl-switch help')
				}
			}
		} Catch {
			[Console]::WriteError('Error: '+ $_)
			Exit
		}
	}
}