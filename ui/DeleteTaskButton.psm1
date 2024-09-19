using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class DeleteTaskButton: Button {
    [int] $SideButtonHeight
    [int] $SideButtonWidth
    [int] $SideButtonX
    [int] $SideButtonY
    [int] $SideButtonPadding
    [string] $TrashIconPath

    DeleteTaskButton() {
        $this.SideButtonHeight = 30
        $this.SideButtonWidth = 30
        $this.SideButtonX = 5
        $this.SideButtonY = 94
        $this.SideButtonPadding = $this.SideButtonHeight + 4
        $this.Size = New-Object Size($this.SideButtonWidth, $this.SideButtonHeight)
        $this.Location = New-Object Point($this.SideButtonX, $this.SideButtonY)

        $this.TrashIconPath = "$($PSScriptRoot)\img\TrashIcon.png"
        $NewImage = [Image]::FromFile($this.TrashIconPath)
        $this.ImageList = New-Object ImageList
        $this.ImageList.ImageSize = New-Object Size( ($this.SideButtonWidth - 5), ($this.SideButtonHeight - 5) )
        $this.ImageList.Images.Add($NewImage)
        $this.ImageIndex = 0

        $this.add_Click( (Add-EventWrapper -Method $this.DeleteTaskButton_Click) )
    }

    [Void] DeleteTaskButton_Click() {
        $MainTabControl = $this.Parent.MainTabControl
        $CurrentTab = $MainTabControl.SelectedTab
        $CurrentIndex = $this.Parent.MainTabControl.SelectedIndex
        $CurrentListView = $CurrentTab.Controls[0]
        $Checked = $CurrentListView.CheckedIndices
        for ($i = $Checked.Count - 1; $i -ge 0; $i--) {
            $this.Parent.MainTabControl.TaskListData[$CurrentIndex].RemoveTaskAt($Checked[$i])
            $CurrentListView.Items.RemoveAt($Checked[$i])
            $this.Parent.IsSaved = $False
        }
    }
}
