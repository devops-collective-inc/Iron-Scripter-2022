function Set-FlawlessUser {
    <#
    .Synopsis
        Modifies a local user on a remote system
    .Description
        Uses New-PSSession to create / modify a user on a remote system
        SSH Is available as an option
    .PARAMETER user
        user to create.  Password will be prompted
    .PARAMETER computerName
        ComputerName(s) to create the user on.
    .PARAMETER connectionUserName
        User name to use for SSH Connection
    .PARAMETER connectionKeyPath
        Path to the key file.
    .EXAMPLE
        Set-FlawlessUser -user Chris -computerName Computer1 -connectionUserName adminUser -connectionKeyPath c:\temp\keyfile
    #>
    [cmdletbinding(DefaultParameterSetName = "default",
                    SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $True)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $user,

        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String[]]$computerName,

        [Parameter(Mandatory = $true)]
        [String]$connectionUserName,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
            if (test-path $_) {
                $true
            } else {
                throw "$_ key file does not exist"
            }
        })]
        [System.IO.FileInfo]$connectionKeyPath,
    )
    Begin{}
    process {
        foreach ($computer in $computername) {
            write-verbose "Working on $computer"
            If ($PSCmdlet.ShouldProcess("$computer", "create user $($user)")) {
                # using SSH Connection
                $connection = @{
                    Hostname    = $computer
                    userName    = $connectionUsername
                    keyPath     = $connectionkeyPath
                }
                Try {
                    # create remote connection
                    $session = new-PSSession @connection -erroraction Stop
                } Catch {
                    Write-Error "Unable to Connect to $computer"
                    Write-Error $_
                    continue
                } finally {}
                invoke-command -Session $session -ScriptBlock {
                    param($user)
                    $userSplat = @{
                        name = $user.username
                        password = $user.credential
                    }
                    try {
                        Set-LocalUser @userSplat -ErrorAction Stop
                        write-verbose "$($user.username) created"
                    } Catch {
                        Write-warning "unable to create $($user.username)"
                        Write-Error $_
                    }
                } -argumentList $user #end of invoke-command
            } # end of shouldProces
        }
    } #end of process
    End {}
}
