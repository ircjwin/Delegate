# Set-PSDebug -Trace 2
Write-Host $PSScriptRoot
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "$($PSScriptRoot)\src\Add-EventWrapper.ps1"
. "$($PSScriptRoot)\src\Get-DefaultBrowser.ps1"
. "$($PSScriptRoot)\src\Get-ChoreListData.ps1"
. "$($PSScriptRoot)\src\Open-Agenda.ps1"

Open-Agenda