Using Module '.\ConfigController.psm1'
Using Module '.\HelpController.psm1'
Using Module '.\InstanceController.psm1'
Using Module '.\ServiceController.psm1'
Using Module '..\Config\Builder.psm1'
Using Module '..\Config\Loader.psm1'
Using Module '..\Utils\Console.psm1'

Class AppController
{
	Static [String] $Version = '0.7.0'

	[Void] Static Run([String[]] $Arguments)
	{
		Try {
			# Verifying arguments
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
				'^all$' {
					$InstanceName = [InstanceController]::Exists($Config, $Arguments[1])	
					[ServiceController]::Execute($Config, $InstanceName, $Config.GetServices() -Join ',')
				}
				'^build$' {
					# Building app in single file (to avoid Powershell "Using module" problems)
					if ([AppController]::IsBuildedApp() -eq $True) {
						Throw 'The builder is only available outside of the builded ps1 file'
					}
					('Builder' -as [Type])::Build((Get-Item $PSScriptRoot).Parent.Parent.FullName, [AppController]::Version)
				}
				'^build-version$' {
					# Returning the version only, only used for the build
					Write-Host ('v'+ [AppController]::Version)
				}
				'^config$' {
					# Opening config.yaml with the default editor
					[Console]::Write('Opening config.json...')
					Invoke-Item $Config.Path
				}
				'^help$' {
					# Display the command list
					[HelpController]::Show()
				}
				'^instances$' {
					# Display the available instance list
					[Console]::Write($Config.GetInstances().Keys -Join ', ')
				}
				'^services$' {
					# Display the available service list
					[Console]::Write($Config.GetServices() -Join ', ')
				}
				'^status$' {
					# Display the status of each service
					[ServiceController]::ShowStatus($Config)
				}
				'^version$' {
					# Showing the app version
					[Console]::Write('wsl-switch version '+ [AppController]::Version)
				}
				$Regex {
					# Execute the switch command
					$InstanceName = [InstanceController]::Exists($Arguments[1])
					[ServiceController]::Execute($Config, $InstanceName, $Command)
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

	[String] Static IsBuildedApp()
	{
		Return (Get-PSCallStack | Select-Object -First 1 -ExpandProperty 'ScriptName') -Match 'wsl-switch.ps1'
	}
}