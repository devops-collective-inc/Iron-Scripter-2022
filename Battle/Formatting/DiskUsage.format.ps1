Write-FormatView -TypeName DiskUsage -Property DEviceID, 'FreeSpace(MB)', 'Size(GB)', '%Free' -VirtualProperty @{
    'FreeSpace(MB)' = { ($_.FreeSpace / 1MB) -as [int] }
    'Size(GB)' = {($_.Size / 1GB) -as [int]}
    '%Free' = {($_.FreeSpace / $_.Size) * 100 -as [int] }
} -ColorProperty @{
    '%Free' = { Format-Heatmap -HeatMapMax 100 -HeatMapMin 0 -HeatMapMiddle 50 -HeatMapHot 0xff0000 -heatMapCool 0x00ff00 }
}
