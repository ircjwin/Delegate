using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class MainMenuStrip: MenuStrip {
    [String] $SaveTitle
    [String] $SaveMsg

    MainMenuStrip() {
        $this.SaveTitle = "Save"
        $this.SaveMsg = "Save changes?"

        $File = New-Object ToolStripMenuItem
        $Save = New-Object ToolStripMenuItem
        $Settings = New-Object ToolStripMenuItem
        $Close = New-Object ToolStripMenuItem
        $File.Text = "File"
        $Save.Text = "Save"
        $Settings.Text = "Settings"
        $Close.Text = "Close"
        $this.Items.Add($File)
        $File.DropDownItems.AddRange( @($Save, $Settings, $Close) )
        $Save.add_Click( (Add-EventWrapper -Method $this.SaveToolStripMenuItem_Click) )
        $Settings.add_Click( (Add-EventWrapper -Method $this.SettingsToolStripMenuItem_Click) )
        $Close.add_Click( (Add-EventWrapper -Method $this.CloseToolStripMenuItem_Click) )
    }

    [Void] SaveToolStripMenuItem_Click() {
        $SaveDataPath = "$($PSScriptRoot)\..\src\Save.json"
        $MsgBtns = [MessageBoxButtons]::YesNo
        $Result = [MessageBox]::Show($this.SaveMsg, $this.SaveTitle, $MsgBtns)
        if ($Result -eq [DialogResult]::Yes) {
            $this.Parent.MainTabControl.ChoreListData | ConvertTo-Json -Depth 3 | Set-Content -Path $SaveDataPath
        }
        $this.Parent.IsSaved = $True
    }

    [Void] SettingsToolStripMenuItem_Click() {
        $this.Parent.SettingsForm.ShowDialog($this.Parent) | Out-Null
    }

    [Void] CloseToolStripMenuItem_Click() {
        $this.Parent.Close()
    }
}
