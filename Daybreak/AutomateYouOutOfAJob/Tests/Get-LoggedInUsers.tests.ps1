Describe 'Get-LoggedInUsers' {
    BeforeAll {
        . $PSScriptRoot/../Public/Get-LoggedInUsers.ps1
    }
    It 'Invokes Cmmand correctly when computername is specified' {
        $cred = [PSCredential]::new(
            'Pester',
            $('Pester' | ConvertTo-SecureString -AsPlainText)
        )
        Mock -Verifiable Invoke-Command -ParameterFilter { 'Pester' -eq $Hostname }
        Get-LoggedInUsers -Hostname 'Pester' | Should -InvokeVerifiable
    }
}
