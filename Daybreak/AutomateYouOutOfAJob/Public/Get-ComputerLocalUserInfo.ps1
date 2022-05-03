Function Get-ComputerLocalUserInfo {
    <#
    .SYNOPSIS
    Retrieves Information for the passed local user
    .DESCRIPTION
    This command gets the local group membership for the passed user. 
    .PARAMETER UserId
    One or more computer names. This parameter accepts pipeline input.
    You cannot use IP addresses or non-canonical computer names.
    .EXAMPLE
    Get-LocalUserInfo -UserId superstve
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
        HelpMessage='User ID to query',
        ValueFromPipeline=$True)]
        [Alias('user')]
        [ValidatePattern('supersteve')]
        [string]$UserId,
    
        [Parameter(Mandatory=$false,
        HelpMessage='Credential object with perms to read local group info',
        ValueFromPipeline=$True)]
        [Alias('creds')]
        [pscredential]$Credentials,
    
        [Parameter(Mandatory=$True,
        HelpMessage='Computer to query',
        ValueFromPipeline=$True)]
        [Alias('server')]
        [pscredential]$ComputerName
    )
    BEGIN {                                                 #
        Write-Output "Begining"                  # these lines are new
    }                                                       #
    PROCESS {
        try {
            $icmParams = @{}
    
            if ($ComputerName) { $icmParams.ComputerName = $ComputerName }
            if ($Credential) { $icmParams.Credential = $Credential }
            if ($UserId) { $icmParams.UserId = $UserId }
    
            Invoke-Command @icmParams {
                Get-Localuser
    
            }
        } catch {
            "failed"
        }
        }
    }
    