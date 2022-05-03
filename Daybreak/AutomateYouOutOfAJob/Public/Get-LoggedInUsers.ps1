function Get-LoggedInUsers {
    <#
    .SYNOPSIS
    Fetches the currently logged in users of the server
    #>
    [CmdletBinding()]
    param(
        #The name of the computer to connect to, defaults to localhost
        [String][Alias('Hostname')]$ComputerName,
        #The credential to use for authentication
        [PSCredential]$Credential
    )

    $icmParams = @{}

    #Hostname implicitly uses SSH as opposed to ComputerName, that's why we specify it here
    if ($ComputerName) { $icmParams.HostName = $ComputerName }
    if ($Credential) { $icmParams.Credential = $Credential }

    Invoke-Command @icmParams {
        #TODO: ANYTHING BUT THIS!
        quser
    }
}
