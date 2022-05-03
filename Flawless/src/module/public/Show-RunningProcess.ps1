
function Show-RunningProcess {
    <#
.SYNOPSIS
Show running process

.DESCRIPTION
This shows the running process

.PARAMETER ComputerName
ComputerName or ComputerNames

.PARAMETER Credential
Credential

.EXAMPLE
Show-RunningProcess -ComputerName computer1 -Credential (Get-Credential)

.NOTES
Flawless FOR life!
#>

    [CmdletBinding()]
    param (
        # Input value description
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [String[]]
        $ComputerName = $ENV:ComputerName,

        [System.Management.Automation.PSCredential]
        $Credential
    )

    process {

        $splat = @{}

        if ($Credential) {
            $splat.Add("Credential", $Credential)
        }

        Invoke-Command @splat -ScriptBlock {
            Get-Process -IncludeUserName | ForEach-Object {
                [PSCustomObject]@{
                    UserName     = $_.UserName
                    PID          = $_.PID
                    Path         = $_.Path
                    ComputerName = $ENV:computername
                }
            } | Select-Object Username, PID, Path, ComputerName
        }
    }
}
