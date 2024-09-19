using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module '..\src\TaskList.psm1'
class RenameTextBox: TextBox {
    [String] $InvalidNameTitle
    [String] $InvalidNameMsg
    [String] $DuplicateNameTitle
    [String] $DuplicateNameMsg

    RenameTextBox() {
        $this.InvalidNameTitle = "Invalid Name"
        $this.InvalidNameMsg = "Please enter a valid name."
        $this.DuplicateNameTitle = "Duplicate Name"
        $this.DuplicateNameMsg = "Name already in use."
        $this.add_KeyDown( (Add-EventWrapper -Method $this.RenameTextBox_KeyDown -SendArgs) )
        $this.add_Leave( (Add-EventWrapper -Method $this.RenameTextBox_Leave -SendArgs) )
    }

    [Void] RenameTextBox_KeyDown([Object] $s, [EventArgs] $e) {
        if ($e.KeyCode -ne "Enter") {
            return
        }
        $e.Handled = $True
        $e.SuppressKeyPress = $True
        $NewTaskListName = $s.Text.Trim()
        if ($NewTaskListName -eq "") {
            $MsgBtns = [MessageBoxButtons]::OK
            [MessageBox]::Show($this.InvalidNameMsg, $this.InvalidNameTitle, $MsgBtns)
            return
        }
        foreach ($TaskList in $this.Parent.TaskListData) {
            if ( ($TaskList.GetName()) -eq $NewTaskListName) {
                $MsgBtns = [MessageBoxButtons]::OK
                [MessageBox]::Show($this.DuplicateNameMsg, $this.DuplicateNameTitle, $MsgBtns)
                return
            }
        }
        if ($this.Parent.MainTabControl.IsNew -eq $True) {
            $NewTaskList = New-Object TaskList
            $this.Parent.MainTabControl.TaskListData.Add($NewTaskList)
            $this.Parent.MainTabControl.IsNew = $False
        }
        $s.Dispose()
        $CurrentIndex = $this.Parent.MainTabControl.SelectedIndex
        $this.Parent.MainTabControl.TaskListData[$CurrentIndex].SetName($NewTaskListName)
        $this.Parent.MainTabControl.SelectedTab.Text = $NewTaskListName + $this.Parent.MainTabControl.SelectedTabWhitespace
        $this.Parent.DeleteTaskListButton.Relocate()
        $this.Parent.DeleteTaskListButton.Visible = $True
        $this.Parent.IsSaved = $False
    }

    [Void] RenameTextBox_Leave([Object] $s, [EventArgs] $e) {
        if ($s.Disposing -eq $True) {
            return
        }
        if ($this.Parent.MainTabControl.IsNew -eq $True) {
            $CurrentTab = $this.Parent.MainTabControl.SelectedTab
            $DefaultName = $CurrentTab.Text.Trim()
            $NewTaskListName = -Split $DefaultName
            $MaxUnnamedCount = 0
            foreach ($TaskList in $this.Parent.MainTabControl.TaskListData) {
                $TaskListName = -Split ( $TaskList.GetName() )
                if ($TaskListName.Count -lt 2 -or $TaskListName.Count -gt 3) {
                    Continue
                }
                if ($TaskListName[0] -eq $NewTaskListName[0] -and $TaskListName[1] -eq $NewTaskListName[1]) {
                    if ($TaskListName.Count -eq 3) {
                        $Num = $TaskListName[2] -as [Int]
                        if ($Null -eq $Num) {
                            Continue
                        }
                        if ($Num -ge $MaxUnnamedCount) {
                            $MaxUnnamedCount = $Num + 1
                        }
                    } else {
                        if ($MaxUnnamedCount -eq 0) {
                            $MaxUnnamedCount = 1
                        }
                    }
                }
            }
            if ($MaxUnnamedCount-gt 0) {
                $DefaultName = "$($DefaultName) $($MaxUnnamedCount)"
                $CurrentTab.Text = $DefaultName + $this.Parent.MainTabControl.SelectedTabWhitespace
            }
            $this.Parent.DeleteTaskListButton.Relocate()
            $NewTaskList = New-Object TaskList
            $NewTaskList.SetName($DefaultName)
            $this.Parent.MainTabControl.TaskListData.Add($NewTaskList)
            $this.Parent.IsSaved = $False
            $this.Parent.MainTabControl.IsNew = $False
        }
        $s.Dispose()
        $this.Parent.DeleteTaskListButton.Visible = $True
    }
}
