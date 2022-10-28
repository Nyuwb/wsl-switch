$Config = @{
	'Instances' = @{
		'trusty' = @{ # Ce paramètre est à votre guise et sera utilisé lors de l'appel des commandes
			'Hostname' = 'trusty'
			'Services' = @{
				'apache' = 'apache2'
				'php' = 'php5-fpm'
				'mysql' = 'mysql'
			}
		}
		'focal' = @{ # Ce paramètre est à votre guise et sera utilisé lors de l'appel des commandes
			'Hostname' = 'focal'
			'Services' = @{
				'apache' = 'apache2'
				'php' = 'php7.4-fpm'
				'mysql' = 'mysql'
			}
		}
	}
	'Path' = ($env:USERPROFILE +'\home\scripts\wsl-switch\')
}