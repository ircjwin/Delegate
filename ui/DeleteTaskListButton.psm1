using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class DeleteTaskListButton: Button {
    [int] $DeleteTaskListButtonHeight
    [int] $DeleteTaskListButtonWidth
    [string] $DeleteCatTitle
    [string] $DeleteCatMsg

    DeleteTaskListButton() {
        $this.DeleteTaskListButtonWidth = 15
        $this.DeleteTaskListButtonHeight = 15
        $this.Size = New-Object Size($this.DeleteTaskListButtonWidth, $this.DeleteTaskListButtonHeight)
        $this.Text = "x"
        $this.add_Click( (Add-EventWrapper -Method $this.DeleteTaskListButton_Click) )
        $this.DeleteCatTitle = "Delete"
        $this.DeleteCatMsg = "Delete list?"
    }

    [Void] Relocate() {
        $CurrentIndex = $this.Parent.MainTabControl.SelectedIndex
        if ($CurrentIndex -eq -1) {
            $CurrentIndex = 0
        }
        $Rect = $this.Parent.MainTabControl.GetTabRect($CurrentIndex)
        $BtnX = $Rect.Right - $this.DeleteTaskListButtonWidth + $this.Parent.MainTabControl.Left
        $BtnY = $Rect.Y + $this.Parent.MainTabControl.Top
        $this.Location = New-Object Point($BtnX, $BtnY)
        $this.BringToFront()
    }

    [Void] DeleteTaskListButton_Click() {
        $CurrentIndex = $this.Parent.MainTabControl.SelectedIndex
        $MsgBtns = [MessageBoxButtons]::YesNo
        $Result = [MessageBox]::Show($this.DeleteCatMsg, $this.DeleteCatTitle, $MsgBtns)
        if ($Result -eq [DialogResult]::Yes) {
            if ($this.Parent.MainTabControl.Controls.Count -eq 2) {
                $CurrentTab = $this.Parent.MainTabControl.SelectedTab
                $CurrentTab.Text = $this.Parent.MainTabControl.DefaultCategory + $this.Parent.MainTabControl.SelectedTabWhitespace
                $CurrentTab.Controls[0].Clear()
                $this.Relocate()
                $this.Parent.AddTaskTextBox.Select()
                $this.Parent.MainTabControl.TaskListData[0].SetName($this.Parent.MainTabControl.DefaultTabTitle)
                $this.Parent.MainTabControl.TaskListData[0].ClearTasks()
            } else {
                if ($CurrentIndex -gt 0) {
                    $this.Parent.MainTabControl.SelectedIndex = ($CurrentIndex - 1)
                }
                $this.Parent.MainTabControl.Controls.RemoveAt($CurrentIndex)
                $this.Parent.MainTabControl.TaskListData.RemoveAt($CurrentIndex)
            }
            $this.Parent.IsSaved = $False
        }
    }
}
