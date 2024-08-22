class AgendaSettings {
	[Boolean] $StartupChecked
	[Boolean] $DeployChecked
	[Array] $EngineOptions
	[List[String]] $EngineChoices

	AgendaSettings() {
		$this.StartupChecked = $False
	}

	[Boolean] GetStartupChecked() {
		return $this.StartupChecked
	}

	[Void] SetStartupChecked([Boolean] $NewStatus) {
		$this.StartupChecked = $NewStatus
	}
}

[AgendaSettings] GetSettings() {
    $FileExists = Test-Path -Path $this.SettingsPath
    If ($FileExists -eq $False) {
        $NewSettings = New-Object AgendaSettings
        $NewSettings | ConvertTo-Json | Set-Content -Path $this.SettingsPath
    }
    $RawJSON = Get-Content -Path $this.SettingsPath -Raw | ConvertFrom-Json
    $NewSettings = [AgendaSettings] $RawJSON
    return $NewSettings
}

[Form] SetSettingsForm() {
    $NewForm = New-Object Form
    $NewLabel = New-Object Label
    $NewCheckBox = New-Object CheckBox
    $NewForm.StartPosition = [FormStartPosition]::CenterParent
    $NewForm.Size = New-Object Size(200, 100)
    $NewLabel.Width = 60
    $NewForm.Location = New-Object Point(0, 0)
    $NewLabel.Location = New-Object Point(10, 13)
    $NewCheckBox.Location = New-Object Point(80, 10)
    $NewForm.Text = "Settings"
    $NewLabel.Text = "On Startup"
    $NewCheckBox.Checked = $this.SettingsData.GetStartupChecked()
    $CheckboxHandler = {
        $s = $Args[0]
        $this.SettingsData.SetStartupChecked($s.Checked)
        $this.SettingsData | ConvertTo-Json | Set-Content -Path $this.SettingsPath
        if ($s.Checked) {
            $WshShell = New-Object -comObject WScript.Shell
            $ShortcutPath = "$([System.Environment]::GetFolderPath("Startup"))\PowerShellAgenda.lnk"
            $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
            $Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
            $Shortcut.Arguments = @"
-WindowStyle Hidden -File "$PSScriptRoot\Driver.ps1"
"@
            $Shortcut.Save()
        } else {
            $ShortcutPath = "$([System.Environment]::GetFolderPath("Startup"))\PowerShellAgenda.lnk"
            Remove-Item $ShortcutPath
        }
    }
    $NewCheckBox.add_Click( (Add-EventWrapper -ScriptBlock $CheckboxHandler -SendArgs) )
    $NewForm.Controls.Add( $NewLabel )
    $NewForm.Controls.Add( $NewCheckBox )
    return $NewForm
}

$this.SettingsPath = "$($PSScriptRoot)\Settings.json"

$this.SettingsData = $this.GetSettings()