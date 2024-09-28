using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class DeleteChoreListButton: Button {
    [int] $DeleteChoreListButtonHeight
    [int] $DeleteChoreListButtonWidth
    [string] $DeleteCatTitle
    [string] $DeleteCatMsg

    DeleteChoreListButton() {
        $this.DeleteChoreListButtonWidth = 15
        $this.DeleteChoreListButtonHeight = 15
        $this.Size = New-Object Size($this.DeleteChoreListButtonWidth, $this.DeleteChoreListButtonHeight)
        $this.Text = "x"
        $this.add_Click( (Add-EventWrapper -Method $this.DeleteChoreListButton_Click) )
        $this.DeleteCatTitle = "Delete"
        $this.DeleteCatMsg = "Delete list?"
    }

    [Void] Relocate() {
        $CurrentIndex = $this.Parent.MainTabControl.SelectedIndex
        if ($CurrentIndex -eq -1) {
            $CurrentIndex = 0
        }
        $Rect = $this.Parent.MainTabControl.GetTabRect($CurrentIndex)
        $BtnX = $Rect.Right - $this.DeleteChoreListButtonWidth + $this.Parent.MainTabControl.Left
        $BtnY = $Rect.Y + $this.Parent.MainTabControl.Top
        $this.Location = New-Object Point($BtnX, $BtnY)
        $this.BringToFront()
    }

    [Void] DeleteChoreListButton_Click() {
        $CurrentIndex = $this.Parent.MainTabControl.SelectedIndex
        $MsgBtns = [MessageBoxButtons]::YesNo
        $Result = [MessageBox]::Show($this.DeleteCatMsg, $this.DeleteCatTitle, $MsgBtns)
        if ($Result -eq [DialogResult]::Yes) {
            if ($this.Parent.MainTabControl.Controls.Count -eq 2) {
                $CurrentTab = $this.Parent.MainTabControl.SelectedTab
                $CurrentTab.Text = $this.Parent.MainTabControl.DefaultCategory + $this.Parent.MainTabControl.SelectedTabWhitespace
                $CurrentTab.Controls[0].Clear()
                $this.Relocate()
                $this.Parent.AddChoreTextBox.Select()
                $this.Parent.MainTabControl.ChoreListData[0].SetName($this.Parent.MainTabControl.DefaultTabTitle)
                $this.Parent.MainTabControl.ChoreListData[0].ClearChores()
            } else {
                if ($CurrentIndex -gt 0) {
                    $this.Parent.MainTabControl.SelectedIndex = ($CurrentIndex - 1)
                }
                $this.Parent.MainTabControl.Controls.RemoveAt($CurrentIndex)
                $this.Parent.MainTabControl.ChoreListData.RemoveAt($CurrentIndex)
            }
            $this.Parent.IsSaved = $False
        }
    }
}
