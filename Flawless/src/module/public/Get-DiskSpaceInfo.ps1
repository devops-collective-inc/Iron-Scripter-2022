[cmdletbinding()]
param(
    [Parameter(
        Mandatory
    )]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [String] $ConfigFilePath
)

function New-SSHSession {
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
        [String[]] $Computer
    )

    process {
        try {
            foreach ($computerName in $Computer) {
                Write-Verbose "Connecting to $computerName"

                New-PSSession -HostName $computerName -KeyFilePath $KeyFilePath -UserName $Username -ErrorAction Stop

            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

function Out-PrettyDiskInfo {
    <#
    .DESCRIPTION

    .EXAMPLE

    #>
    [cmdletbinding()]
    param(
        # Input value description
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [PSObject[]] $DiskInfo
    )

    process {
        try {
            foreach ($disk in $DiskInfo) {
                Write-Verbose "Processing [$disk]"

                if ($disk.SizeInGB -lt ($disk.TotalSize / 100) * 90) {
                    "$($PSStyle.Background.BrightRed)Size in GB: $($disk.SizeInGB)$($PSStyle.Reset)"
                } else {
                    "$($PSStyle.Background.Green)Size in GB: $($disk.SizeInGB)$($PSStyle.Reset)"
                }

            }
        } catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}

$configObject = Get-Content -Path $ConfigFilePath | ConvertFrom-Json

$configObject.Hosts |

    ForEach-Object -Process {
        New-SSHSession -KeyFilePath $configObject.KeyFilePath -Username $configObject.Username -Computer $_
    } |

    ForEach-Object -Process {
        Invoke-Command -Session $_ -ScriptBlock { Get-Disk }
    } |

    ForEach-Object -Process {
        Out-PrettyDiskInfo -DiskInfo $_
    }
