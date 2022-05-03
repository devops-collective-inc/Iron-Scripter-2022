function Get-VersionInfo {
    <#
    .SYNOPSIS
    Show running process

    .DESCRIPTION
    A unified command to return version information for installed versions of PowerShell, the operating system, and the ssh version.
    .PARAMETER Computer

    .PARAMETER Username

    .PARAMETER KeyFilePath

    .PARAMETER SSHVersion

    .PARAMETER PSVersion

    .PARAMETER OSVersion

    .EXAMPLE
    Get-VersionInfo -SSHVersion -OSVersion -PSVersion

    .NOTES
    Flawless FOR life!
    #>

    [cmdletbinding()]
    param(
        # Input value description
        [Parameter(
            Mandatory
        )]
        [string] $KeyFilePath,

        [Parameter(
            Mandatory
        )]
        [string] $Username,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [String] $Computer,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Switch] $osVersion,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Switch] $SSHVersion,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Switch] $PSVersion
    )

    process {
        try {
            Write-Verbose "Connecting to $computerName"

            New-PSSession -HostName $computerName -KeyFilePath $KeyFilePath -UserName $Username -ErrorAction Stop
            New-SSHSession -KeyFilePath $KeyFilePath -Username $Username -Computer $Computer |

                ForEach-Object -Process {
                    Invoke-Command -Session $_ -ScriptBlock {
                        if ($SSHVersion) {
                            ssh -V
                        }
                        if ($OSVersion) {
                            $PSVersionTable.OS
                        }
                        if ($PSVersion) {
                            $PSVersionTable.PSVersion.ToString()
                        }
                    }
                }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}
