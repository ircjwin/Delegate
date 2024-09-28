using module "..\ui\MainForm.psm1"


function Open-Agenda {
<#
.SYNOPSIS
   Open agenda application
.DESCRIPTION
   This function initializes a new instance of the Agenda class and opens the
   application for use.
#>
	$App = New-Object MainForm
	$App.Open()
}

Get-Command
Open-Agenda