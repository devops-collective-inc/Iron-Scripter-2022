foreach ($file in Get-ChildItem -Path $psScriptRoot -Filter *-*.ps1) {
    . $file.Fullname
}