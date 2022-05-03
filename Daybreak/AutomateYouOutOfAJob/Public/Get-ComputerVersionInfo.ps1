function Get-ComputerVersionInfo {
    <#
    .SYNOPSIS
    Returns a object containing information about system versions
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

        [pscustomobject]@{
            OperatingSystem     = [System.Environment]::OSVersion
            PowerShellVersion   = $PSVersionTable.PSCompatibleVersions
            SSHVersion          = Get-Command -Name ssh.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Version
        }

    }

}