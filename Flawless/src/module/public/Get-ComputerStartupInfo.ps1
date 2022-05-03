Function Get-ComputerStartupInfo {
    <#
    .SYNOPSIS
    Get information about the last startup, shutdown, and/or restart.

    .DESCRIPTION
    This script uses CIM and Get-WinEvent to retrieve time information for computer(s)
        last boot time
        system uptime
        build date
        etc.

    .PARAMETER ComputerName
    The name of the computer or computers

    .PARAMETER Credential
    Credential object to use to retrieve data

    .EXAMPLE
    Get-LastBoot -ComputerName SERVER
    This example returns boot time information for SERVER

    .EXAMPLE
    Get-LastBoot -ComputerName SERVER1,SERVER2,SERVER3 -Credential $Cred
    This example returns boot time information for the listed servers using the given credentials

    .INPUTS
    ComputerName(s) and alternate credential

    .OUTPUTS
    LastBoot

    .NOTES
    Author: Darwin Reiswig

    Lovingly reused by joshooaj of Flawless Faction
    #>

    [CmdletBinding(PositionalBinding = $false)]
    [OutputType([LastBoot])]
    param(
        [Parameter(ValueFromPipeline, Position = 0, ParameterSetName = 'Name')]
        [alias("Name")]
        [alias("PSComputerName")]
        [string[]]$ComputerName = 'localhost',

        [Parameter()]
        [pscredential]
        $Credential
    )

    begin {
        Write-Verbose "Begin $($MyInvocation.MyCommand)"
        [ScriptBlock]$GetEvents = {
            #Event 41 = The system has rebooted without cleanly shutting down first.
            Get-WinEvent -FilterHashtable @{Logname = 'System'; ID = 41 } -MaxEvents 1 -ErrorAction SilentlyContinue
            #Event 6008 = The previous system shutdown was unexpected.
            Get-WinEvent -FilterHashtable @{Logname = 'System'; ID = 6008 } -MaxEvents 1 -ErrorAction SilentlyContinue
            #Event 1074 = Normal Restart
            Get-WinEvent -FilterHashtable @{Logname = 'System'; ID = 1074 } -MaxEvents 1 -ErrorAction SilentlyContinue
        }

        [ScriptBlock]$ResolveSid = {
            param($sid)
            try {
                $objSID = New-Object System.Security.Principal.SecurityIdentifier($sid)
                $objSID.Translate([System.Security.Principal.NTAccount])
            } catch {
                Write-Warning "Unable to resolve SID to username"
            }
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Downtime = [timespan]::Zero
            Write-Verbose "Retrieving CIM data for $Computer"
            $cimDataParams = @{
                ClassName    = 'win32_operatingsystem'
                ComputerName = $Computer
            }
            if ($Credential) {
                $cimDataParams.Credential = $Credential
            }
            $CIMData = Get-CimInstance @cimDataParams

            Write-Verbose "Querying event log for $Computer for shutdown events."
            $params = @{
                ComputerName = $Computer
                ErrorAction  = 'Stop'
                ScriptBlock  = $GetEvents
            }
            if ($Credential) {
                $params.Credential = $Credential
            }
            $EventList = @(Invoke-Command @params)

            If ($EventList.count -gt 0) {
                Write-Verbose "Calculating downtime"
                $LastShutdownEvent = ($EventList | Sort-Object -Property timecreated -Descending -ErrorAction Stop)[0]
                $LastShutdownTime = $LastShutdownEvent.timecreated
                switch ($LastShutdownEvent.Id) {
                    41 { $LastShutdownType = "Unexpected" }
                    6008 { $LastShutdownType = "Unexpected" }
                    1074 {
                        $LastShutdownType = "Normal"
                        $Downtime = $CIMData.LastBootUpTime - $LastShutdownTime
                        if (-not [string]::IsNullOrWhitespace($CIMData.UserId)) {
                            $LastShutdownUser = $ResolveSid.Invoke($CIMData.UserId)
                        }
                    }
                    Default { $LastShutdownType = "Unknown" }
                }
            } else {
                Write-Verbose "Unable to acquire shutdown data from event log"
                $LastShutdownTime = [datetime]"1/1/1900"
                $LastShutdownType = "Unknown"
            }

            Write-Verbose "Compiling output data for $Computer"
            $Result = [pscustomobject]@{
                PSTypeName       = 'LastBoot'
                ComputerName     = $CIMData.CSName
                LastShutdownTime = $LastShutdownTime
                Downtime         = $Downtime
                DowntimeDays     = $Downtime.ToString("dd\.hh\:mm\:ss")
                LastBootUpTime   = $CIMData.LastBootUpTime
                Uptime           = $CIMData.LocalDateTime - $CIMData.LastBootUpTime
                UptimeDays       = ($CIMData.LocalDateTime - $CIMData.LastBootUpTime).ToString("dd\.hh\:mm\:ss")
                InstallDate      = $CIMData.InstallDate
                ShutdownType     = $LastShutdownType
                LastShutdownUser = $LastShutdownUser
            }
            $Result
        }
    }

    end {
        Write-Verbose "End $($MyInvocation.MyCommand)"
    }
}
