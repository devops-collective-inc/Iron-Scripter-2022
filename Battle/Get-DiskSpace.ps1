function Get-DiskSpace {
<#.SYNOPSIS
    This script will generate a report showing the physical disk utilization on the system specified.
.DESCRIPTION
    This script will generate a report showing the disk utilization on the system specified.  You can sepcify the computername or 
    it will choose the localohist by default.
    Final Version 6/6/2019
.EXAMPLE
    Get-Disk | .\get-diskspace.ps1
.EXAMPLE
    .\get-diskspace.ps1 -number 0
.PARAMETER Number
    Mandatory. is the windisk number, for the first drive this will be zero.
.OUTPUTS
    A table displayed is the conole will show the disk usage
#>
param (     [parameter(mandatory=$true, ValueFromPipelineByPropertyName)][int]   $Number )
process{
    if ( get-disk -number $Number ) 
    {
        $TotalSpace = (Get-disk -number $Number).size
        $ListofParitions = Get-Partition
        $Windisk = $Number
        write-verbose "The WinDisk $WinDisk"
        write-verbose "the space usage is as follows"
        $UsedSpace = 0
        foreach($Partition in $ListofParitions)
        { 
                $UsedSpace = $UsedSpace + $Partition.size
        }
        Write-verbose "The Space used is $UsedSpace"
        Write-verbose "The Total Space is $TotalSpace"
        $FreeSpace = $TotalSpace - $UsedSpace
        Write-verbose "The Free Space is $FreeSpace"
        $ReturnObj = [ordered]@{
            PSTypeName = 'DiskSpace' 
            Total   = $TotalSpace
            Used    = $UsedSpace
            Free    = $FreeSpace
        }
        return $ReturnObj
    }
}
}