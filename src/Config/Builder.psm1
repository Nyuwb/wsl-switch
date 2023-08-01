
Class Builder
{
	[Void] Static Build([String] $RootPath, [String] $Version)
	{
		# Config
		$AppFile = $RootPath +'\wsl-switch.ps1'
		$ScoopJsonFile = $RootPath +'\wsl-switch.json'

		# Dependencies
		$Dependencies = @(
			'src\Config\Loader.psm1',
			'src\Controller\AppController.psm1',
			'src\Controller\ConfigController.psm1',
			'src\Controller\HelpController.psm1',
			'src\Controller\InstanceController.psm1',
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

		# Inserting in file
		New-Item -ItemType File -Path $AppFile -Force | Out-Null
		Add-Content $AppFile $Content

		# Generating release file (zip file)
		$ReleaseFile = $RootPath +'\build\wsl-switch-v'+ $Version +'.zip'
		Get-ChildItem -Path ($RootPath +'\*') -Include wsl-switch.ps1,LICENSE,config.json | Compress-Archive -DestinationPath $ReleaseFile -Update
	}
}