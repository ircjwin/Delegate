using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module '..\src\AgendaSettings.psm1'


class SettingsForm: Form {
    [String] $SettingsPath
    [AgendaSettings] $SettingsData

    SettingsForm() {
        $this.SettingsPath = "$($PSScriptRoot)\Settings.json"
        $this.SettingsData = $this.GetSettings()
        $this.StartPosition = [FormStartPosition]::CenterParent
        $this.Size = New-Object Size(200, 100)
        $this.Location = New-Object Point(0, 0)
        $this.Text = "Settings"

        $NewLabel = New-Object Label
        $NewLabel.Width = 60
        $NewLabel.Location = New-Object Point(10, 13)
        $NewLabel.Text = "On Startup"

        $NewCheckBox = New-Object CheckBox
        $NewCheckBox.Location = New-Object Point(80, 10)
        $NewCheckBox.Checked = $this.SettingsData.GetStartupChecked()
        $NewCheckBox.add_Click( (Add-EventWrapper -Method $this.CheckBox_Click -SendArgs) )

        $this.Controls.Add( $NewLabel )
        $this.Controls.Add( $NewCheckBox )
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

    [Void] CheckBox_Click() {
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
}
