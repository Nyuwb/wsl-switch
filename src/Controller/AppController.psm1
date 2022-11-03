Using Module '.\ConfigController.psm1'
Using Module '.\ServiceController.psm1'
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
			# Generating command
			$Command = ($Arguments[0] -Split ' ') -Join ','
			# Generating regex for the services
			$Regex = '^('+ $Config.FormatServicesToString() +')$'
			# Getting command from first argument
			Switch -Regex ($Command) {
				'^config$' {
					# Opening config.yaml with the default editor
					[Console]::Write('Opening config.json...')
					Invoke-Item 'config.json'
				}
				'^help$' {
					# Display the command list
					[Console]::Write("Usage: wsl-switch [command] [optional arguments]`n")
					[Console]::Write("Global commands:")
					[Console]::Write("   config`t`tOpen the configuration file")
					[Console]::Write("   help`t`t`tShow this message")
					[Console]::Write("   instances`t`tShow the instance list")
					[Console]::Write("   services`t`tShow the service list")
					[Console]::Write("   version`t`tShow the application version")
					[Console]::Write("`nService switch, enable the service on the entered instance name and disable it on the other one:")
					[Console]::Write("   apache foo`t`tActivate apache on foo")
					[Console]::Write("   mysql bar`t`tActivate mysql on bar")
					[Console]::Write("   php baz`t`tActivate php on baz`n")
					[Console]::Write("The services can be written comma-separated to enable them together, for example :")
					[Console]::Write("   apache,php foo`tActivate apache and php on foo`n")
				}
				'^instances$' {
					# Display the available instance list
					[Console]::Write($Config.GetInstances().Keys -Join ', ')
				}
				'^services$' {
					# Display the available service list
					[Console]::Write($Config.GetServices() -Join ', ')

				}
				'^version$' {
					# Showing the app version
					[Console]::Write('wsl-switch version '+ $Config.GetVersion())
				}
				$Regex {
					# Checking instance name
					$InstanceName = $Arguments[1]
					If ($Config.InstanceExists($InstanceName) -ne $True) {
						Throw ('The instance '''+ $InstanceName +''' doesn''t exist')
					}
					# Calling the command
					[ServiceController]::Call($Config, $InstanceName, $Command)
				}
				Default {
					Throw (''''+ $Command +''' is not a valid command, please check wsl-switch help')
				}
			}
		} Catch {
			[Console]::WriteError('Error: '+ $_)
			Exit
		}
	}
}