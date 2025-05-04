BeforeAll {
    . "$PSScriptRoot/../../Banxico.CLABE/internal/functions/Test-CLABE.ps1"
}

Describe 'Test-CLABE' {
    It 'Returns success as true' {
        $Output = Test-CLABE -CLABE 044939000118359712
        $Output.Success      | Should -BeTrue
        $Output.ControlDigit | Should -Be 2
    }

    It 'Returns success as false' {
        $Output = Test-CLABE -CLABE 044939000118359710
        $Output.Success      | Should -BeFalse
        $Output.ControlDigit | Should -Be 0
    }
}