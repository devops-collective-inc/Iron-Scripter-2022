Write-FormatView -Property PID, VIRT, '%CPU', '%MEM', 'TIME+', 'Command' -virtualproperty @{
    PID = { $_.ID}
    '%CPU' = { if ($_.CPU) { $_.CPU.ToString('N')} else { }}
    '%MEM' = { $_.WorkingSet}
    VIRT = { $_.VirtualMemorySize }
    'TIME+' = { [DateTime]::now - $_.StartTime} 
    Command = { $_.CommandLine }   
} -TypeName Watch.Process.Top
