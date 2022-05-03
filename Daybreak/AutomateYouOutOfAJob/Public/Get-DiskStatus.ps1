Function Get-DiskStatus
{
    <#
    .SYNOPSIS
    Displays the disk usage
    
    Inputs: MinFree - highlihts volumes with a minimum free capacity in %
            FilterVolume - list output for single volume
    #>

    [CmdletBinding()]
    param(
        #The name of the computer to connect to, defaults to localhost
        [String][Alias('Hostname')]$ComputerName,

        [PSCredential]$Credential,

        [Parameter(Mandatory= $False)]
        [String]$MinFree,

        [Parameter(Mandatory= $False)]
        [String]$FilterVolumes
    )

    $icmParams = @{}

    #Hostname implicitly uses SSH as opposed to ComputerName, that's why we specify it here
    if ($ComputerName) { $icmParams.HostName = $ComputerName }
    if ($Credential) { $icmParams.Credential = $Credential }

    $ListOfVolumes  = Invoke-Command @icmParams {
        Get-Volume;
    }

    $ListOfVolumes | Foreach-object {


        if ( ( $_.DriveLetter -eq $FilterVolumes ) -or $FilterVolumes -eq "" ) {
            $_
        }
    }

}