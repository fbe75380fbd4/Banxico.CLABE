<#
.SYNOPSIS

Lists the branch offices or cities used by CLABE.

.DESCRIPTION

Lists the branch offices or cities used by CLABE where the checking account is located
within Mexico.

Be aware that there might be multiple branch offices under the same code.

.PARAMETER Code
Specifies the branch office code to be searched for. Optional.

.OUTPUTS

System.Object[]. Get-BranchOfficeData returns an object array of branch offices.

.EXAMPLE

PS> Get-BranchOfficeData

Code BranchOffice
---- ------------
001  TEST1
002  TEST2
003  TEST3
...

.EXAMPLE

PS> Get-BranchOfficeData -Code 999

Code BranchOffice
---- ------------
999  TEST

#>
function Get-BranchOfficeData
{
	[CmdletBinding()]
	Param (
		[Parameter()]
		[ValidatePattern('^[\d]{3}$')]
		[string]
		$Code
	)

	begin
	{
		$Data = @()
	}
	process
	{
		$Data = Import-Csv -Path "$PSScriptRoot\..\internal\data\BranchOffices.csv"
	}
	end
	{
		if ($Code)
		{
			$Data = $Data | Where-Object {$_.Code -eq $Code}
		}

		return $Data
	}
}
