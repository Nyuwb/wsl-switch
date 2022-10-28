#WSLSwitch
Set-Alias switch-wsl D:\Développement\wsl-switch\\app.ps1
Function WSLSwitchApache { switch-wsl apache $args }
Set-Alias switch-apache WSLSwitchApache
Function WSLSwitchMysql { switch-wsl mysql $args }
Set-Alias switch-mysql WSLSwitchMysql
Function WSLSwitchPhp { switch-wsl php $args }
Set-Alias switch-php WSLSwitchPhp
Function WSLSwitchApacheMysql { switch-wsl apache,mysql $args }
Set-Alias switch-apache-mysql WSLSwitchApacheMysql
Function WSLSwitchApachePhp { switch-wsl apache,php $args }
Set-Alias switch-apache-php WSLSwitchApachePhp
Function WSLSwitchMysqlPhp { switch-wsl mysql,php $args }
Set-Alias switch-mysql-php WSLSwitchMysqlPhp
Function WSLSwitchAll { switch-wsl apache,mysql,php $args }
Set-Alias switch-all WSLSwitchAll
#WSLSwitchEnd
