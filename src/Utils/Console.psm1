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