<#
.DESCRIPTION
Testing the main script
#>

Describe "Main Script" {
    BeforeAll {
        $password = ConvertTo-SecureString "MyPlainTextPassword" -AsPlainText -Force
        $Cred = New-Object System.Management.Automation.PSCredential ("username", $password)
    }

    It "Handles a credential" {
        $result = Show-RunningProcess -Credential $Cred
        $result | Should -Not -BeNullOrEmpty
    }

    It "Outputs the username" {
        $result = Show-RunningProcess
        $result.UserName | Should -Not -BeNullOrEmpty
    }

    It "Outputs the ComputerName" {
        $result = Show-RunningProcess
        $result.ComputerName | Should -Not -BeNullOrEmpty
    }
}
