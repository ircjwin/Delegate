using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class CheckAllButton: Button {
    [int] $SideButtonHeight
    [int] $SideButtonWidth
    [int] $SideButtonX
    [int] $SideButtonY
    [int] $SideButtonPadding
    [string] $CheckIconPath

    CheckAllButton() {
        $this.SideButtonHeight = 30
        $this.SideButtonWidth = 30
        $this.SideButtonX = 5
        $this.SideButtonY = 94
        $this.SideButtonPadding = $this.SideButtonHeight + 4
        $this.Size = New-Object Size($this.SideButtonWidth, $this.SideButtonHeight)
        $this.Location = New-Object Point($this.SideButtonX, ($this.SideButtonY + $this.SideButtonPadding) )

        $this.CheckIconPath = "$($PSScriptRoot)\img\CheckIcon.png"
        $NewImage = [Image]::FromFile($this.CheckIconPath)
        $this.ImageList = New-Object ImageList
        $this.ImageList.ImageSize = New-Object Size( ($this.SideButtonWidth - 10), ($this.SideButtonHeight - 10) )
        $this.ImageList.Images.Add($NewImage)
        $this.ImageIndex = 0

        $this.add_Click( (Add-EventWrapper -Method $this.CheckButton_Click) )
    }

    [Void] CheckButton_Click() {
        $MainTabControl = $this.Parent.MainTabControl
        $CurrentTab = $MainTabControl.SelectedTab
        $CurrentListView = $CurrentTab.Controls[0]
        foreach ($Task in $CurrentListView.Items) {
            $Task.Checked = $True
        }
    }
}
