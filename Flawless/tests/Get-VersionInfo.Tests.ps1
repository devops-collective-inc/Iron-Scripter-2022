<#
.DESCRIPTION
Testing the main script
#>

Describe "Main Script" {
    BeforeAll {

    }

    It "Runs Correctly" {
        $result = Get-VersionInfo
        $result.OSVersion | Should -Not -BeNullOrEmpty
        $result.PSVersion | Should -Not -BeNullOrEmpty
        $result.SSHVersion | Should -Not -BeNullOrEmpty
    }
}
