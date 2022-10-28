Using Module "..\src\Config\Installer.psm1"
Using Module "..\src\Config\Loader.psm1"
Using Module "..\src\Utils\Console.psm1"

$Config = [Loader]::New()
[Installer]::Install($Config, $Profile)