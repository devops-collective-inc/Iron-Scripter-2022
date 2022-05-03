<#
.DESCRIPTION
Testing the main script
#>

Describe "Main Script" {

    BeforeAll {
        $username = Get-Secret -Name 'SSH-Test-User'
        $computerName = 'Test-2019-Server'
    }
    It "Gets SSHSession" {
        $session = Get-SSHSession -Username $username -Computer $computerName
        $result | Should -Not -BeNullOrEmpty
    }
    It "Get disk spaceinfo" {
        $session = Get-SSHSession -Username $username -Computer $computerName
        $info = Get-DiskSpaceInfo -Session $session
        $info | Should -Not -BeNullOrEmpty

    }
}
