## src\Config\Loader.psm1

Class Loader
{
	[Hashtable] $Instances = @{}
	[Array] $Services
	[String] $Version = '0.5'
	[String] $Path

	Loader()
	{
		# Get the root path
		$RootPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName
		$This.Path = $RootPath +'\config.json'
		# Load of the configuration
		$Config = Get-Content $This.Path -Raw | ConvertFrom-JSON
		# Saving the configuration in the current class
		$This.Services = $Config.Services
		$This.SetInstances($Config.Instances)
	}

	# Checking if an instance name exists
	[Boolean] InstanceExists([String] $InstanceName)
	{
		Return ($This.GetInstances().Keys -Contains $InstanceName)
	}

	[Instance] GetByInstanceName([String] $InstanceName)
	{
		Return $This.GetInstances()[$InstanceName]
	}

	[System.Collections.ArrayList] GetOtherInstancesThan([String] $InstanceName)
	{
		$InstanceList = [System.Collections.ArrayList]::New()
		$This.GetInstances().Keys | Foreach-Object {
			If ($_ -ne $InstanceName) {
				$InstanceList.Add($This.GetByInstanceName($_))
			}
		}
		Return $InstanceList
	}

	# Associate every service together to generate a string that will be used as a regex for the command
	[String] FormatServicesToString()
	{
		$ServiceList = New-Object System.Collections.Generic.List[System.Object]
		For ($i = 0; $i -lt $This.Services.Length; $i++) {
			$ServiceList.Add($This.Services[$i])
			# Getting associated service list
			If ($i -ne $This.Services.Length -1) {
				$SubServiceList = New-Object System.Collections.Generic.List[System.Object]
				$SubServiceList.Add($This.Services[$i])
				For ($j = ($i + 1); $j -lt $This.Services.Length; $j++) {
					$ServiceList.Add($This.Services[$i] +','+ $This.Services[$j])
					$SubServiceList.Add($This.Services[$j])
				}
				$ServiceList.Add($SubServiceList.ToArray() -Join ',')
			}
		}
		$ServicesArray = $ServiceList.ToArray() | Select -Unique
		Return ($ServicesArray -Join '|')
	}
	
	# Setter list
	[Void] SetInstances($InstanceList)
	{
		$InstanceList.PSObject.Properties | Foreach-Object {
			$Instance = [Instance]::New($_.Name, $_.Value.Hostname, $_.Value.Services)
			$This.Instances[$_.Name] = $Instance
		}
	}

	# Getter list
	[Hashtable] GetInstances()
	{
		Return $This.Instances
	}

	[System.Object] GetServices()
	{
		Return $This.Services
	}

	[String] GetVersion()
	{
		Return $This.Version
	}
}

## src\Controller\AppController.psm1

Class AppController
{
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
				'^build$' {
					# Building app in single file (to avoid Powershell "Using module" problems)
					if (-Not ('Builder' -as [Type])) {
						Throw 'The builder is only available outside of the build ps1 file'
					}
					('Builder' -as [Type])::Build((Get-Item $PSScriptRoot).Parent.Parent.FullName)	
				}
				'^config$' {
					# Opening config.yaml with the default editor
					[Console]::Write('Opening config.json...')
					Invoke-Item $Config.Path
				}
				'^help$' {
					# Display the command list
					[Console]::Write("Usage: wsl-switch [command] [optional arguments]`n")
					[Console]::Write("Global commands:")
					[Console]::Write("   config`t`t`tOpen the configuration file")
					[Console]::Write("   help`t`t`t`tShow this message")
					[Console]::Write("   instances`t`t`tShow the instance list")
					[Console]::Write("   services`t`t`tShow the service list")
					[Console]::Write("   version`t`t`tShow the application version")
					[Console]::Write("`nService switch, enable the service on the entered instance name and disable it on the other one:")
					[Console]::Write("   apache foo`t`t`tActivate apache on foo")
					[Console]::Write("   mysql bar`t`t`tActivate mysql on bar")
					[Console]::Write("   php baz`t`t`tActivate php on baz`n")
					[Console]::Write("The services can be written comma-separated to enable them together, for example:")
					[Console]::Write("   apache,php foo`t`tActivate apache and php on foo")
					[Console]::Write("   apache,mysql,php bar`t`tActivate apache, mysql and php on bar`n")
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

## src\Controller\ConfigController.psm1
Class ConfigController
{
	Static CheckConfigurationFile()
	{
		$ConfigFile = (Get-Item $PSScriptRoot).Parent.Parent.FullName +'\config.json'
		# Checking if the configuration file
		if ((Test-Path -Path $ConfigFile) -eq $False) {
			Throw 'The configuration file ''config.json'' has not been found, please reinstall the application'
		}

		# Checking the content
		$Content = Get-Content $ConfigFile -Raw
		If ([ConfigController]::TestJson($Content) -eq $False) {
			Throw 'The configuration file content is not a valid JSON'
		}

		# Checking services and instances correlation
		$Content = $Content | ConvertFrom-JSON
		[ConfigController]::CheckJsonContent($Content)
	}

	[Boolean] Static TestJson([String] $Content)
	{
		$TestJson = $False
		try {
			$Content | ConvertFrom-JSON -ErrorAction Stop
			$TestJson = $True
		} catch {
			$TestJson = $False
		}
		Return $TestJson
	}

	[Void] Static CheckJsonContent($Content)
	{
		# Checking services
		$Services = $Content.Services
		If ($Services -eq $null) {
			Throw 'The services property is missing in the configuration'
		}

		# Checking instances
		$InstanceLength = 0
		$Content.Instances.PSObject.Properties | Foreach-Object {
			$InstanceLength += 1
			$InstanceName = $_.Name
			# Checking the hostname
			If ($_.Value.Hostname -eq $null) {
				Throw 'Hostname invalid for the instance '''+ $InstanceName +''''
			}
			# Checking the service list
			$InstanceServices = $_.Value.Services.PSObject.Properties.Name
			$Services | ForEach-Object {
				If ($InstanceServices -NotContains $_) {
					Throw 'The service '''+ $_ +''' doesn''t exists for the instance '''+ $InstanceName +''''
				}
			}
		}
		If ($InstanceLength -le 1) {
			Throw 'The instances property is invalid in the configuration'
		}
	}
}

## src\Controller\ServiceController.psm1

Class ServiceController
{
	[Void] Static Call([Loader] $Config, [String] $Hostname, [String] $ServiceList)
	{
		# Getting instance list config (which should be activated and deactivated)
		$InstanceList = @{
			'start' = $Config.GetByInstanceName($Hostname)
			'stop' = $Config.GetOtherInstancesThan($Hostname)
		}

		# Execution of the WSL commands
		'stop', 'start' | Foreach-Object {
			$Action = $_
			$InstanceList[$Action] | Foreach-Object {
				$Instance = $_
				[Console]::Write($(If ($Action -eq 'stop') { 'Dea' } else { 'A' }) +'ctivation of the services on the instance '+ $Instance.GetHostname() +"...`n")
				$ServiceList -Split ',' | ForEach-Object {
					$Service = $_
					[Command]::Execute($Instance.GetHostname(), $Instance.GetService($Service), $Action)
				}
			}
		}
	}
}

## src\Entity\Instance.psm1

Class Instance
{
	[String] $Id
	[String] $Hostname
	[Hashtable] $Services = @{}

	Instance($Id, $Hostname, $Services)
	{	
		$This.Id = $Id
		$This.Hostname = $Hostname
		$This.SetServices($Services)
	}

	# Setter list
	[Void] SetServices($Services)
	{
		$Services.PSObject.Properties | Foreach-Object {
			$Service = [Service]::New($_.Name, $_.Value)
			$This.Services[$_.Name] = $Service
		}
	}

	# Getter list
	[String] GetId()
	{
		Return $This.Id
	}

	[String] GetHostname()
	{
		Return $This.Hostname
	}

	[System.Object] GetServices()
	{
		Return $This.Services
	}

	[System.Object] GetService($Service)
	{
		Return $This.Services[$Service]
	}
}

## src\Entity\Service.psm1
Class Service
{
	[String] $Name
	[String] $Process

	Service($Name, $Process)
	{	
		$This.Name = $Name
		$This.Process = $Process
	}

	# Getter list
	[String] GetName()
	{
		Return $This.Name
	}

	[String] GetProcess()
	{
		Return $This.Process
	}
}

## src\Utils\Command.psm1

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

## src\Utils\Console.psm1
Class Console
{
	[Void] Static Write([String] $Message)
	{
		Write-Host $Message
	}

	[Void] Static WriteError([String] $Message)
	{
		Write-Host $Message -ForegroundColor 'Red'
	}

	[Void] Static WriteSuccess([String] $Message)
	{
		Write-Host $Message -ForegroundColor 'Green'
	}
}

## run.ps1

# Starting application
[AppController]::Run($Args)


