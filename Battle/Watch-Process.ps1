function Watch-Process
{
    <#
    .Synopsis
        Watches processes running.
    .Description
        Watches processes running and sorts them by CPU utilization and memory consumption
    .Example
        Watch-Process
    .Link
        Get-Process
    #>
    [Alias('topProc')]
    param(
    # The amount of time to watch for
    [TimeSpan]
    $WatchFor,

    # the refresh interval
    [Timespan]
    $RefreshInterval = '00:00:05',

    # The number of processes to display, by default 20.
    [int]
    $NumberOfProcesses = 20
    )

    $WatchUntil =
        if ($WatchFor) {
            [DateTime]::now  + $WatchFor
        } else {
            [Datetime]::now.AddDays(1)
        }

    do {
        Get-Process  |
            Sort-Object CPU, WorkingSet -Descending |
            Select-Object -First $NumberOfProcesses |
            Foreach-Object {
                $_.pstypenames.clear()
                $_.pstypenames.add('Watch.Process.Top')
                $_
            } 

        Start-Sleep -Milliseconds $RefreshInterval.TotalMilliseconds
    } while ([Datetime]::now - $WatchUntil)
}
