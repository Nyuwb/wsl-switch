Using Module '.\src\Controller\AppController.psm1'

# Starting application
$Env:RootPath = $PSScriptRoot
[AppController]::Run($Args)