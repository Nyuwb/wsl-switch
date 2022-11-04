
Class Builder
{
	[Void] Static Build([String] $RootPath)
	{
		# Config
		$Version = '0.5'
		$AppFile = $RootPath +'\wsl-switch.ps1'

		# Dependencies
		$Dependencies = @(
			'src\Config\Loader.psm1',
			'src\Controller\AppController.psm1',
			'src\Controller\ConfigController.psm1',
			'src\Controller\ServiceController.psm1',
			'src\Entity\Instance.psm1',
			'src\Entity\Service.psm1',
			'src\Utils\Command.psm1',
			'src\Utils\Console.psm1',
			'run.ps1'
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
	}
}