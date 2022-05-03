function Get-ServerStatus {
    <#
    .SYNOPSIS
    Monitors the performance of the server in real time
    #>
    [CmdletBinding()]
    param(
        #The name of the computer to connect to, defaults to localhost
        [String][Alias('Hostname')]$ComputerName,
        #The credential to use for authentication
        [PSCredential]$Credential,
        #How many lines you wish to have displayed for Top
        [int]$Lines = 10,
        [int]$RefreshSec = 1
    )

    $icmParams = @{}

    #Hostname implicitly uses SSH as opposed to ComputerName, that's why we specify it here
    if ($ComputerName) { $icmParams.HostName = $ComputerName }
    if ($Credential) { $icmParams.Credential = $Credential }

    Invoke-Command @icmParams {
        while ($true) {
            Clear-Host

            Get-Process
            | Select-Object -First 10
            | Sort-Object CPU
            | Format-Table -AutoSize

            Start-Sleep $refreshSec
        }
    }
}
