BeforeAll {
    . "$PSScriptRoot/../../Banxico.CLABE/functions/Get-InstitutionData.ps1"

    Mock Invoke-WebRequest {return @{StatusCode = 200; Content = '<tr><td>99999</td><td>TEST</td></tr>'}}
}

Describe 'Get-InstitutionData' {
    It 'Returns data from Banxico' {
        $Output = Get-InstitutionData -Code 999
        $Output.Institution | Should -Be 'TEST'
        $Output.Code        | Should -Be 999
    }

    It 'Unable to retrieve data from Banxico' {
        Mock Invoke-WebRequest {return @{StatusCode = 404; Content = $null}}
        Mock Write-Error
        Get-InstitutionData -Code 999
        Should -Invoke Write-Error -Times 1
    }
}