<#
.DESCRIPTION
Testing the main script
#>

Describe "Main Script" {
    BeforeAll {

    }

    It "Runs Correctly" {
        $result = Set-FlawlessUser -User user1 -ComputerName wee -ConnectionUserName This -KeyPath ./txt
        $result | Should -Not -BeNullOrEmpty
    }

    It "Supports pipeline input without errors" {
        $result = "computer","computer2" | Set-FlawlessUser -User user1 -ConnectionUserName This -KeyPath ./txt
        $result | Should -Not -BeNullOrEmpty
    }

    It "Must provide Connection UserName" {
        $result = Set-FlawlessUser -ComputerName wee -ConnectionUserName This -KeyPath ./txt
        $result | Should Throw
    }
}
