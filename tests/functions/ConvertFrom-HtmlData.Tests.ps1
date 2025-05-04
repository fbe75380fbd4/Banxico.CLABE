BeforeAll {
    . "$PSScriptRoot/../../Banxico.CLABE/internal/functions/ConvertFrom-HtmlData.ps1"
}

Describe 'ConvertFrom-HtmlData' {
    It 'Returns data from HTML' {
        $Output = ConvertFrom-HtmlData -Html "<tr><td>40999</td><td>TEST</td></tr>"
        $Output.Institution | Should -Be 'TEST'
        $Output.Code        | Should -Be 999
    }
}