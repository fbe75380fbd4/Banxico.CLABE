<#
.SYNOPSIS

Tests a CLABE code by performing calculations.

.DESCRIPTION

Tests a CLABE code by performing calculations to verify the control digit.

.PARAMETER CLABE
Specifies the CLABE code to be validated. Mandatory.

.OUTPUTS

PSCustomObject. Test-CLABE returns an object with the result of the calculations.

.EXAMPLE

PS> Test-CLABE -CLABE 044939000118359712

ControlDigit Success
------------ -------
2               True

#>
function Test-CLABE
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
			ControlDigit  = $CLABE.Substring(17, 1)
			Success       = $false
		}
	}
	process
	{
		$ModulusSum    = 0
		$Positions     = @(3, 7, 1)
		$PositionIndex = 0

		foreach ($char in $CLABE.Substring(0, 17).ToCharArray())
		{
			$ModulusSum += ([int]::Parse($char) * [int]::Parse($Positions[$PositionIndex])) % 10

			$PositionIndex += 1

			if ($PositionIndex -ge 3)
			{
				$PositionIndex = 0
			}
		}

		$ControlDigit = (10 - ($ModulusSum % 10)) % 10

		$Output.Success = $Output.ControlDigit -eq $ControlDigit
	}
	end
	{
		return $Output
	}
}
