using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module ".\CheckAllButton.psm1"
using module ".\DeleteTaskButton.psm1"
using module ".\UncheckAllButton.psm1"
using module ".\MainTabControl.psm1"
using module ".\AddTaskTextBox.psm1"
using module ".\MainMenuStrip.psm1"
using module ".\DeleteTaskListButton.psm1"
using module '.\SettingsForm.psm1'
using module '.\TaskDetailsForm.psm1'


class MainForm: Form {
    [AddTaskTextBox] $AddTaskTextBox
    [MainTabControl] $MainTabControl
    [DeleteTaskListButton] $DeleteTaskListButton
    [String] $UnsavedTitle
    [String] $UnsavedMSg
    [Boolean] $IsSaved
    [SettingsForm] $SettingsForm
    [TaskDetailsForm] $TaskDetailsForm

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
        $DeleteTaskButton = New-Object DeleteTaskButton
        $MainMenuStrip = New-Object MainMenuStrip
        $this.DeleteTaskListButton = New-Object DeleteTaskListButton
        $this.MainTabControl = New-Object MainTabControl($this.Height, $this.Width)
        $this.AddTaskTextBox = New-Object AddTaskTextBox($this.MainTabControl.Size, $this.MainTabControl.Location)
        $this.SettingsForm = New-Object SettingsForm
        $this.TaskDetailsForm = New-Object TaskDetailsForm

        $this.Controls.Add($this.AddTaskTextBox)
        $this.Controls.Add($this.MainTabControl)
        $this.Controls.Add($this.DeleteTaskListButton)
        $this.Controls.Add($MainMenuStrip)
        $this.Controls.Add($DeleteTaskButton)
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
            $this.DeleteTaskListButton.Relocate()
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
