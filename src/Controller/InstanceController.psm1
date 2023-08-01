Using Module '..\Config\Loader.psm1'

Class InstanceController
{
	# Check if the instance exists
	# Returns it's name if it exists otherwise throws an exception
	[String] Static Exists([Loader] $Config, [String] $InstanceName)
	{
		# Check if the instance exists in the configuration
		If ($Config.InstanceExists($InstanceName) -ne $True) {
			Throw ('The instance '''+ $InstanceName +''' doesn''t exist in the configuration file')
		}
		Return $InstanceName
	}

}