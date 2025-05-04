<#
.SYNOPSIS

Converts HTML table rows and columns into an object array.

.DESCRIPTION

Converts HTML table rows and columns from Banxico's web site into a list of
banking institutions as an object array.

.PARAMETER Html
Specifies the HTML string to be processed. Mandatory.

.OUTPUTS

System.Object[]. ConvertFrom-HtmlData returns an object array from the html string.

.EXAMPLE

PS> ConvertFrom-HtmlData -Html "<tr><td>99999</td><td>TEST</td></tr>"

Code Institution
---- -----------
999  TEST

#>
function ConvertFrom-HtmlData
{
	[OutputType([System.Object[]])]
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
    	[string]
		$Html
	)

	begin
	{
		$Output = @()
	}
	process
	{
		# Matches lines like "<tr><td>40044</td><td>SCOTIABANK</td></tr>"
		$Pattern = '<tr\>\<td\>(?<Code>[\d]+)\<\/td\>\<td\>(?<Institution>[\w]+)\<\/td\>\<\/tr\>'

		$Results = $Html | Select-String $Pattern -AllMatches

		$Results.Matches | ForEach-Object {
			$Groups = $_ | Select-Object -ExpandProperty Groups
			$Output += [pscustomobject]@{
				# CLABE only uses the last 3 digits for each institution code
				Code        = $Groups.Value[1].Substring($Groups.Value[1].Length - 3)
				Institution = $Groups.Value[2]
			}
		}
	}
	end
	{
		return $Output
	}
}
