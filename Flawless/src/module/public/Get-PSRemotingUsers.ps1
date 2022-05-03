function Get-PSRemotingUsers {
    <#
    .DESCRIPTION
    show remote connected users using PowerShell remoting. Include both traditional connections and ssh.The output should show the user name, when they connected, how long connected, and if possible their source IP address

    .EXAMPLE
    Get-PSRemotingUsers -ComputerName 'YourPC1'
    #>
    [cmdletbinding()]
    param(
        # Input value description
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]$ComputerName = $env:COMPUTERNAME
    )

    process {
        try {
            $RemoteInfo = @()
            foreach ($Computer in $ComputerName) {
                Write-Verbose "Processing [$ComputerName]"
                
                $RemoteInfo.add([PSCustomObject]@{
                    UserName        = (Get-CimInstance -Class win32_computersystem -ComputerName $ComputerName).UserName
                    IPAddress       = (Get-CimInstance -Class Win32_NetworkClient -ComputerName $ComputerName).IPAddress
                    WhenConnected   = (Get-CimInstance -Class Win32_LogonSession -ComputerName $ComputerName).StartTime
                    LengthConnected = (Get-CimInstance -Class Win32_LogonSession -ComputerName $ComputerName).LengthConnected
                }]
            }
            return $RemoteInfo | Format-Table
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
