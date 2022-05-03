function Get-ComputerUptimeInfo {
    <#
    .SYNOPSIS
    Returns a object containing information about system uptime
    #>
    [CmdletBinding()]
    param(
        #The name of the computer to connect to, defaults to localhost
        [String][Alias('Hostname')]$ComputerName,
        [PSCredential]$Credential
    )

    $icmParams = @{}

    #Hostname implicitly uses SSH as opposed to ComputerName, that's why we specify it here
    if ($ComputerName) { $icmParams.HostName = $ComputerName }
    if ($Credential) { $icmParams.Credential = $Credential }

    Invoke-Command @icmParams {

        $LastStartupEvent = Get-WinEvent -FilterHashtable @{ LogName='System'; Id=6005 } -MaxEvents 1
        $LastShutdownEvent = Get-WinEvent -FilterHashtable @{ LogName='System'; Id=6006 } -MaxEvents 1


        [pscustomobject]@{
            LastShutdown        = $LastShutdownEvent.TimeCreated
            LastStartup         = $LastStartupEvent.TimeCreated
            DownTime            = $LastStartupEvent.TimeCreated - $LastShutdownEvent.TimeCreated
            UpTime              = (Get-Date) - $LastStartupEvent.TimeCreated
        }

    }

}