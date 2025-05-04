BeforeAll {
    . "$PSScriptRoot/../../Banxico.CLABE/functions/Get-BranchOfficeData.ps1"
}

Describe 'Get-BranchOfficeData' {
    It 'Returns data from CSV' {
        $Output = Get-BranchOfficeData -Code 939
        $Output.BranchOffice | Should -Be 'Loreto'
        $Output.Code         | Should -Be 939
    }
}