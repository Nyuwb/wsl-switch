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
					
				}
				'config' {
					# Opening config.yaml with the default editor
					Invoke-Item 'config.yaml'
					[Console]::Write('Opening config.yaml... after you finished, please use the command "wsl-switch config-update"')
				}
				'config-update' {
					# TODO
				}
				'test' {
					[Console]::Write($Arguments)
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