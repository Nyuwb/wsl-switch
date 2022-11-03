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