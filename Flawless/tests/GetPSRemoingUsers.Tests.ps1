<#
.DESCRIPTION
Testing the main script
#>

Describe "Main Script" {
    BeforeAll {

    }

    It "Runs Correctly" {
        $result = Invoke-Main
        $result | Should -Not -BeNullOrEmpty
    }
}
