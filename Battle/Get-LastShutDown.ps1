


function Get-LastShutDown {
<#
  .synopsis
    Gets the last shutdown of the local machine or for machines connected to one or more sessions
   .Example 
        PS> $sess = New-PSSession -VMName octo 
        PS> Get-LastShutDown -Session $sess
   
        Creates as session and requests the last shutdown time for it
#>
    [cmdletBinding()]
    param ( 
        [Parameter(ValueFromPipeline=$true)]
        #The session for a remote machine 
        $Session
    )
    begin {
        $scriptblock  = { 
            $event = Get-WinEvent -FilterHashtable @{logname="system"; id="1074"} | Sort-Object TimeCreated | Select-Object -First 1
            #Reduce event to time and key parts of the message 
            [psCustomObject]@{"Time"=$event.TimeCreated   
                            "Message" = (($event.message -split  "`n\s*" -replace "^.*:\s*(.*:.*)",'$1' ) -Join [System.Environment]::newLine)
            }
        }
    }
    process {
        if ($Session) {
            $result = foreach ($s in $session) {
                Invoke-Command -Session $S -ScriptBlock $scriptblock
            }
        }   
        else {  $result = Invoke-Command -ScriptBlock $scriptblock}
        #Strip remoting properties and add a type for formatting
        $result | Select-Object Time, Messaage | ForEach-Object {$_.pstypenames.add('LastShutdown') ; $_} 
    } 
}