Get-ChildItem -Path $PSScriptRoot/Public
| ForEach-Object {
    . $PSItem
}
