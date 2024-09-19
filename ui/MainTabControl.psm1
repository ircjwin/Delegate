using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module ".\ListViewBuilder.psm1"
using module '..\src\TaskList.psm1'
using module '.\RenameTextBox.psm1'


class MainTabControl: TabControl {
    [int] $TabControlHeight
    [int] $TabControlWidth
    [int] $TabControlX
    [int] $TabControlY
    [string] $SelectedTabWhitespace
    [string] $AddTabPageText
    [string] $UnnamedTabTitle
    [string] $DefaultTabTitle
    [TabPage] $AddTabPage
    [List[TaskList]] $TaskListData
    [Boolean] $IsNew

    MainTabControl([int] $FormHeight, [int] $FormWidth) {
        $this.TabControlHeight = $FormHeight - 100
        $this.TabControlWidth = $FormWidth - 85
        $this.TabControlX = 35
        $this.TabControlY = 40
        $this.Location = New-Object Point($this.TabControlX, $this.TabControlY)
        $this.Size = New-Object Size($this.TabControlWidth, $this.TabControlHeight)
        $this.Multiline = $True

        $this.DefaultTabTitle = "General"
        $this.UnnamedTabTitle = "New List"
        $this.SelectedTabWhitespace = " " * 5

        $this.AddTabPage = New-Object TabPage
        $this.AddTabPage.Text = "   +"
        $this.IsNew = $False

        $this.TaskListData = (Get-TaskListData -DefaultName $this.DefaultTabTitle)

        $this.add_SelectedIndexChanged( (Add-EventWrapper -Method $this.MainTabControl_SelectedIndexChanged) )
        $this.add_Deselected( (Add-EventWrapper -Method $this.MainTabControl_Deselected -SendArgs) )
        $this.add_DoubleClick( (Add-EventWrapper -Method $this.MainTabControl_DoubleClick) )

        $this.TabPageBuilder()
        $this.Controls.Add($this.AddTabPage)
    }

    [void] TabPageBuilder() {
        foreach ($TaskList in $this.TaskListData) {
            $NewTab = New-Object TabPage
            $NewTab.Text = $TaskList.GetName()
            $TaskDescList = $TaskList.Tasks | ForEach-Object { $_.GetDesc() }
            $NewListView = New-Object ListViewBuilder($this.TabControlHeight, $this.TabControlWidth, $TaskDescList)
            $NewTab.Controls.Add($NewListView)
            # $NewTab.add_Click( (Add-EventWrapper -Method $this.BlurredControl_Click) )
            $this.Controls.Add($NewTab)
        }
    }

    [Void] MainTabControl_SelectedIndexChanged() {
        $CurrentTab = $this.SelectedTab
        if ($CurrentTab -eq $this.AddTabPage) {
            $this.Parent.DeleteTaskListButton.Visible = $False
            $this.IsNew = $True
            $NewTabPage = New-Object TabPage
            $NewTabPage.Text = $this.UnnamedCategory
            $NewListView = New-Object ListViewBuilder($this.TabControlHeight, $this.TabControlWidth, @())
            $NewTabPage.Controls.Add($NewListView)
            # $NewTabPage.add_Click( (Add-EventWrapper -Method $this.BlurredControl_Click) )
            $this.TabPages.Insert( ($this.Controls.Count - 1), $NewTabPage )
            $this.SelectedTab = $NewTabPage
            $CurrentIndex = $this.SelectedIndex
            $Rect = $this.GetTabRect($CurrentIndex)
            $RenameTextBox = New-Object RenameTextBox
            $RenameTextBox.Location = New-Object Point( ($Rect.X + $this.TabControlX), ($Rect.Y + $this.TabControlY) )
            $RenameTextBox.Size = New-Object Size($Rect.Size)
            $RenameTextBox.Text = $NewTabPage.Text.Trim()
            $this.Parent.Controls.Add($RenameTextBox)
            $RenameTextBox.BringToFront()
            $RenameTextBox.Focus()
            $RenameTextBox.SelectAll()
        } else {
            $CurrentTab.Text = $CurrentTab.Text + $this.SelectedTabWhitespace
            $this.Parent.DeleteTaskListButton.Relocate()
        }
    }

    [Void] MainTabControl_Deselected([Object] $s, [EventArgs] $e) {
        $PrevTab = $e.TabPage
        if ($PrevTab.Disposing -eq $False -and $PrevTab -ne $this.AddTabPage) {
            $PrevTab.Text = $PrevTab.Text.Trim()
        }
    }

    [Void] MainTabControl_DoubleClick() {
        $this.DeleteTaskListButton.Visible = $False
        $CurrentTab = $this.SelectedTab
        $CurrentIndex = $this.SelectedIndex
        $Rect = $this.GetTabRect($CurrentIndex)
        $RenameTextBox = New-Object RenameTextBox
        $RenameTextBox.Location = New-Object Point( ($Rect.X + $this.TabControlX), ($Rect.Y + $this.TabControlY) )
        $RenameTextBox.Size = New-Object Size($Rect.Size)
        $RenameTextBox.Text = $CurrentTab.Text.Trim()
        $this.Parent.Controls.Add($RenameTextBox)
        $RenameTextBox.BringToFront()
        $RenameTextBox.Focus()
        $RenameTextBox.SelectAll()
    }
}