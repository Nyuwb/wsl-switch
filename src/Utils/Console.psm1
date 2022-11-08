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

	# No New Line version
	[Void] Static WriteNNL([String] $Message)
	{
		Write-Host $Message -NoNewline
	}

	[Void] Static WriteErrorNNL([String] $Message)
	{
		Write-Host $Message -ForegroundColor 'Red' -NoNewline
	}

	[Void] Static WriteSuccessNNL([String] $Message)
	{
		Write-Host $Message -ForegroundColor 'Green' -NoNewline
	}
}