[CmdletBinding()]
param()
$Script:PSModuleRoot = $PSScriptRoot

$folders = 'private', 'public'
foreach ($folder in $folders) {
    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if (Test-Path -Path $root) {
        Write-Verbose -Message "Importing files from [$folder]..."
        $files = Get-ChildItem -Path $root -Filter '*.ps1' -Recurse |
            Where-Object Name -NotLike '*.Tests.ps1'

        foreach ($file in $files) {
            Write-Verbose -Message "Dot sourcing [$($file.BaseName)]..."
            . $file.FullName
        }
    }
}

Write-Verbose -Message 'Exporting Public functions...'
$functions = Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1' -Recurse

Export-ModuleMember -Function $functions.BaseName
