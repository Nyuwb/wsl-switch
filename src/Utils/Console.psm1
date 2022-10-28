Class Console
{
	Static WriteError($Message)
	{
		Write-Host $Message -ForegroundColor 'Red'
	}

	Static WriteSuccess($Message)
	{
		Write-Host $Message -ForegroundColor 'Green'
	}
}