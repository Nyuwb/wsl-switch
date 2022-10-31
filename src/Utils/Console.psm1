Class Console
{
	Static Write($Message)
	{
		Write-Host $Message
	}

	Static WriteError($Message)
	{
		Write-Host $Message -ForegroundColor 'Red'
	}

	Static WriteSuccess($Message)
	{
		Write-Host $Message -ForegroundColor 'Green'
	}
}