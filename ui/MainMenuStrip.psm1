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
        $Close.add_Click( (Add-EventWrapper -Method $this.CloseToolStripMenuItem_Click) )
    }

    [Void] CloseToolStripMenuItem_Click() {
        $this.Parent.Close()
    }
}

# [MenuStrip] SetMainMenuStrip() {
#     $Save.add_Click( (Add-EventWrapper -Method $this.SaveToolStripMenuItem_Click) )
#     $SettingsHandler = {
#         $this.SettingsForm.ShowDialog($this.MainForm) | Out-Null
#     }
#     $Settings.add_Click( (Add-EventWrapper -ScriptBlock $SettingsHandler) )
#     return $NewMenuStrip
# }

# [Void] SaveToolStripMenuItem_Click() {
#     $MsgBtns = [MessageBoxButtons]::YesNo
#     $Result = [MessageBox]::Show($this.SaveMsg, $this.SaveTitle, $MsgBtns)
#     if ($Result -eq [DialogResult]::Yes) {
#         $this.AgendaData | ConvertTo-Json -Depth 3 | Set-Content -Path $this.SaveDataPath
#     }
#     $this.IsSaved = $True
# }