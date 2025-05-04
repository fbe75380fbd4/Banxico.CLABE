BeforeAll {
    . "$PSScriptRoot/../../Banxico.CLABE/functions/Get-CLABEInfo.ps1"

    Mock Get-BranchOfficeData {return @{Code = '939'; BranchOffice = 'TEST'}}
    Mock Get-InstitutionData {return @{Code = '044'; Institution = 'TEST'}}
}

Describe 'Get-CLABEInfo' {
    It 'Returns CLABE information' {
        $Output = Get-CLABEInfo -CLABE 044939000118359712
        $Output.Institution   | Should -Be 'TEST (044)'
        $Output.BranchOffice  | Should -Be 'TEST (939)'
        $Output.AccountNumber | Should -Be '00011835971'
        $Output.ControlDigit  | Should -Be 2
        $Output.Valid         | Should -BeTrue
        
    }

    It 'Returns CLABE information with warnings' {
        Mock Get-BranchOfficeData
        Mock Get-InstitutionData
        Mock Write-Warning
        $Output = Get-CLABEInfo -CLABE 012345678901234567
        $Output.Valid | Should -BeFalse
        Should -Invoke Write-Warning -Times 3
    }
}