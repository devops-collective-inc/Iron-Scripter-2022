Write-FormatView -TypeName DiskSpace -Property  '%Free' -VirtualProperty @{
    'FreeSpace(GB)' = { ($_.FreeSpace / 1gb) -as [int] }
    'Size(GB)' = {($_.Total / 1GB) -as [int]}
    '%Free' = {($_.FreeSpace / $_.Total) * 100 -as [int] }
} -ColorProperty @{
    '%Free' = { Format-Heatmap -HeatMapMax 100 -HeatMapMin 0 -HeatMapMiddle 50 -HeatMapHot 0xff0000 -heatMapCool 0x00ff00 }
}
