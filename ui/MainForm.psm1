using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module ".\CheckAllButton.psm1"
using module ".\DeleteChoreButton.psm1"
using module ".\UncheckAllButton.psm1"
using module ".\MainTabControl.psm1"
using module ".\AddChoreTextBox.psm1"
using module ".\MainMenuStrip.psm1"
using module ".\DeleteChoreListButton.psm1"
using module '.\SettingsForm.psm1'
using module '.\ChoreDetailsForm.psm1'


class MainForm: Form {
    [AddChoreTextBox] $AddChoreTextBox
    [MainTabControl] $MainTabControl
    [DeleteChoreListButton] $DeleteChoreListButton
    [String] $UnsavedTitle
    [String] $UnsavedMSg
    [Boolean] $IsSaved
    [SettingsForm] $SettingsForm
    [ChoreDetailsForm] $ChoreDetailsForm

    MainForm() {
        $this.Height = 800
        $this.Width = 600
        $this.Name = "MainForm"
        $this.Text = "Delegate"
        $this.StartPosition = [FormStartPosition]::CenterScreen
        $this.UnsavedTitle = "Unsaved Changes"
        $this.UnsavedMsg = "Unsaved changes will be lost. Continue without saving?"
        $this.IsSaved = $True

        $UncheckAllButton = New-Object UncheckAllButton
        $CheckAllButton = New-Object CheckAllButton
        $DeleteChoreButton = New-Object DeleteChoreButton
        $MainMenuStrip = New-Object MainMenuStrip
        $this.DeleteChoreListButton = New-Object DeleteChoreListButton
        $this.MainTabControl = New-Object MainTabControl($this.Height, $this.Width)
        $this.AddChoreTextBox = New-Object AddChoreTextBox($this.MainTabControl.Size, $this.MainTabControl.Location)
        $this.SettingsForm = New-Object SettingsForm
        $this.ChoreDetailsForm = New-Object ChoreDetailsForm

        $this.Controls.Add($this.AddChoreTextBox)
        $this.Controls.Add($this.MainTabControl)
        $this.Controls.Add($this.DeleteChoreListButton)
        $this.Controls.Add($MainMenuStrip)
        $this.Controls.Add($DeleteChoreButton)
        $this.Controls.Add($CheckAllButton)
        $this.Controls.Add($UncheckAllButton)

        $this.add_Shown( (Add-EventWrapper -Method $this.MainForm_Shown) )
        $this.add_FormClosing( (Add-EventWrapper -Method $this.MainForm_FormClosing -SendArgs) )
    }

    [Void] Open() {
        $this.ShowDialog() | Out-Null
        $this.SettingsForm.Dispose()
        $this.Dispose()
    }

    [Void] MainForm_Shown() {
        if ($this.MainTabControl.Controls.Count -gt 2) {
            foreach ($CurrentTab in $this.MainTabControl.Controls) {
                if ($CurrentTab -ne $this.MainTabControl.AddTabPage) {
                    $this.MainTabControl.SelectedTab = $CurrentTab
                }
            }
            $this.MainTabControl.SelectedIndex = 0
        } else {
            $this.MainTabControl.Controls[0].Text += $this.MainTabControl.SelectedTabWhitespace
            $this.DeleteChoreListButton.Relocate()
        }
    }

    [Void] MainForm_FormClosing([Object] $s, [EventArgs] $e) {
        if ($this.IsSaved -eq $False) {
            $MsgBtns = [MessageBoxButtons]::YesNo
            $Result = [MessageBox]::Show($this.UnsavedMsg, $this.UnsavedTitle, $MsgBtns)
            if ($Result -eq [DialogResult]::No) {
                $e.Cancel = $True
            }
        }
    }
}
