<#
.SYNOPSIS

Retrieves a list of banking institutions from Banxico's web site.

.DESCRIPTION

Retrieves a list of banking institutions from Banxico's web site as html to be processed
internally in order to generate an object array of banking institutions.

.PARAMETER Code
Specifies the institution code to be searched for. Optional.

.OUTPUTS

System.Object[]. Get-InstitutionData returns an object array of banking institutions.

.EXAMPLE

PS> Get-InstitutionData

Code Institution
---- -----------
001  TEST1
002  TEST2
003  TEST3
...

.EXAMPLE

PS> Get-InstitutionData -Code 999

Code Institution
---- -----------
999  TEST

#>
function Get-InstitutionData {
	[CmdletBinding()]
	param (
		[Parameter()]
		[ValidatePattern('^[\d]{3}$')]
		[string]
		$Code
	)
	
	begin {
		$Data = @()
	}
	process {
		$Response = Invoke-WebRequest -Uri 'https://www.banxico.org.mx/cep-scl/listaInstituciones.do' -UseBasicParsing

		if ($Response.StatusCode -ne 200) {
			Write-Error "Unable to retrieve data from Banxico."
		}
		else {
			$Data = ConvertFrom-HtmlData -Html $Response.Content
		}
	}
	end {
		if ($Code) {
			$Data = $Data | Where-Object { $_.Code -eq $Code }
		}

		return $Data
	}
}
