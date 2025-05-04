<#
.SYNOPSIS

Displays the details about a CLABE.

.DESCRIPTION

Displays the details about a CLABE like its banking institution and branch office, also
validates the control digit.

Validation could be subject to change or failure as it depends on external catalogs.

.PARAMETER CLABE
Specifies the CLABE code to be inspected. Mandatory.

.OUTPUTS

PSCustomObject. Get-CLABEInfo returns an object with details about a CLABE.

.EXAMPLE

PS> Get-CLABEInfo -CLABE 044939000118359712

Institution   : TEST (044)
BranchOffice  : TEST (939)
AccountNumber : 00011835971
ControlDigit  : 2
Valid         : True

#>
function Get-CLABEInfo
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[ValidatePattern('^[\d]{18}$')]
    	[string]
		$CLABE
	)

	begin
	{
		$Output = [pscustomobject]@{
			Institution   = ''
			BranchOffice  = ''
			AccountNumber = ''
			ControlDigit  = ''
			Valid         = $false
		}

		$ValidData        = $true
		$InstitutionCode  = $CLABE.Substring(0, 3)
		$BranchOfficeCode = $CLABE.Substring(3, 3)
		$ControlDigit     = $CLABE.Substring(17, 1)
	}
	process
	{
		# Institution
		$InstitutionData = Get-InstitutionData -Code $InstitutionCode

		if (-not $InstitutionData)
		{
			$ValidData   = $false
			$Institution = "UNKNOWN ($InstitutionCode)"
			Write-Warning "Unknown Institution with code: $InstitutionCode"
		}
		else
		{
			$Institution = "$($InstitutionData.Institution) ($($InstitutionData.Code))"
		}

		# Branch Office
		$BranchOfficeData = Get-BranchOfficeData -Code $BranchOfficeCode

		if (-not $BranchOfficeData)
		{
			$ValidData   = $false
			$BranchOffice = "UNKNOWN ($BranchOfficeCode)"
			Write-Warning "Unknown Branch Office with code: $BranchOfficeCode"
		}
		else
		{
			$BranchOffice = "$($BranchOfficeData.BranchOffice -join ', ') ($($BranchOfficeData.Code | Select-Object -Unique))"
		}

		# Control Digit
		$ControlDigitTest = Test-CLABE -CLABE $CLABE

		if ($ControlDigitTest.Success -eq $false)
		{
			$ValidData = $false
			Write-Warning "Invalid Control Digit ($ControlDigit)"
		}

		$Output.Institution   = $Institution
		$Output.BranchOffice  = $BranchOffice
		$Output.AccountNumber = $CLABE.Substring(6, 11)
		$Output.ControlDigit  = $ControlDigit
		$Output.Valid         = $ValidData
	}
	end
	{
		return $Output
	}
}
