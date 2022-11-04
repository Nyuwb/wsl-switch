
Class Builder
{
	[Void] Static Build([String] $RootPath)
	{
		# Config
		$Version = '0.6'
		$AppFile = $RootPath +'\wsl-switch.ps1'

		# Dependencies
		$Dependencies = @(
			'src\Config\Loader.psm1',
			'src\Controller\AppController.psm1',
			'src\Controller\ConfigController.psm1',
			'src\Controller\HelpController.psm1',
			'src\Controller\ServiceController.psm1',
			'src\Entity\Instance.psm1',
			'src\Entity\Service.psm1',
			'src\Utils\Command.psm1',
			'src\Utils\Console.psm1',
			'app.ps1'
    	)

		# Building
		[String] $Content = ""
		ForEach ($Dependency in $Dependencies) {
			# Loading the file full path
			$File = Get-Item -Path ($RootPath +'\'+ $Dependency)

			# Inserting file content
			$Content += "## "+ $Dependency +"`n"
			Get-Content $File.FullName | ForEach-Object {
				If ($_ -NotMatch '^Using module' -and $_ -NotMatch '`s') {
					$Content += $_ +"`n"
				}
			}
			$Content += "`n"
		}

		# Updating version
		$Content = $Content.Replace('{{ version }}', $Version)

		# Inserting in file
		New-Item -ItemType File -Path $AppFile -Force | Out-Null
		Add-Content $AppFile $Content

		# Generating release file (zip file)
		$ReleaseFile = $RootPath +'\wsl-switch-v'+ $Version +'.zip'
		Get-ChildItem -Path ($RootPath +'\*') -Include wsl-switch.ps1,LICENSE,config.json | Compress-Archive -DestinationPath $ReleaseFile -Update

		# Generating wsl-switch.json content
		$Url = 'https://github.com/Nyuwb/wsl-switch/releases/download/v'+ $Version +'/wsl-switch-v'+ $Version +'.zip'
		$ScoopJson = @{
			'version' = $Version
			'description' = 'Switch WSL service activation from an host to another'
			'homepage' = 'https://github.com/Nyuwb/wsl-switch/'
			'license' = 'Apache-2.0'
			'url' = $Url
			'hash' = (Get-FileHash $ReleaseFile -Algorithm SHA256).Hash
			'bin' = 'wsl-switch.ps1'
			'persist' = 'config.json'
			'checkver' = 'github'
			'autoupdate' = @{
				'url' = 'https://github.com/Nyuwb/wsl-switch/releases/download/v$version/wsl-switch-v$version.zip'
			}
		}

		# Updating the file content
		$File = Get-Item -Path ($RootPath +'\wsl-switch.json')
		Add-Content $AppFile ($ScoopJson | ConvertTo-Json)
	}
}