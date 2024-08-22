using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module ".\ListViewBuilder.psm1"


class MainTabControl: TabControl {
    [int] $TabControlHeight
    [int] $TabControlWidth
    [int] $TabControlX
    [int] $TabControlY
    [string] $SelectedTabWhitespace
    [string] $AddTabPageText
    [string] $UnnamedCategory
    [string] $DefaultCategory
    [TabPage] $AddTabPage

    MainTabControl([int] $FormHeight, [int] $FormWidth) {
        $this.TabControlHeight = $FormHeight - 100
        $this.TabControlWidth = $FormWidth - 85
        $this.TabControlX = 35
        $this.TabControlY = 40
        $this.Location = New-Object Point($this.TabControlX, $this.TabControlY)
        $this.Size = New-Object Size($this.TabControlWidth, $this.TabControlHeight)
        $this.Multiline = $True

        $this.DefaultCategory = "General"
        $this.UnnamedCategory = "New List"
        $this.SelectedTabWhitespace = " " * 5

        $this.AddTabPage = New-Object TabPage
        $this.AddTabPage.Text = "   +"

        $TabPage = New-Object TabPage
        $TabPage.text = "General"
        $TabPage2 = New-Object TabPage
        $TabPage2.Text = "Colonel"
        $TabPage3 = New-Object TabPage
        $TabPage3.Text = "Admiral"
        $ListView = New-Object ListViewBuilder($this.TabControlHeight, $this.TabControlWidth)
        $TabPage.Controls.Add($ListView)
        $this.Controls.AddRange( @($TabPage, $TabPage2, $TabPage3) )
        $this.Controls.Add($this.AddTabPage)

        $this.add_SelectedIndexChanged( (Add-EventWrapper -Method $this.MainTabControl_SelectedIndexChanged) )
        $this.add_Deselected( (Add-EventWrapper -Method $this.MainTabControl_Deselected -SendArgs) )
        $this.add_DoubleClick( (Add-EventWrapper -Method $this.MainTabControl_DoubleClick) )
    }

    [Void] MainTabControl_SelectedIndexChanged() {
        $CurrentTab = $this.SelectedTab
        if ($CurrentTab -eq $this.AddTabPage) {
            $this.Parent.DeleteTaskListButton.Visible = $False
            # $this.IsNew = $True
            $NewTabPage = New-Object TabPage
            $NewTabPage.Text = $this.UnnamedCategory
            # $NewListView = $this.SetListView( @() )
            # $NewTabPage.Controls.Add($NewListView)
            # $NewTabPage.add_Click( (Add-EventWrapper -Method $this.BlurredControl_Click) )
            $this.TabPages.Insert( ($this.Controls.Count - 1), $NewTabPage )
            $this.SelectedTab = $NewTabPage
            # $CurrentIndex = $this.SelectedIndex
            # $Rect = $this.GetTabRect($CurrentIndex)
            # $RenameTextBox = New-Object TextBox
            # $RenameTextBox.Location = New-Object Point( ($Rect.X + $this.TabControlX), ($Rect.Y + $this.TabControlY) )
            # $RenameTextBox.Size = New-Object Size($Rect.Size)
            # $RenameTextBox.Text = $NewTabPage.Text.Trim()
            # $RenameTextBox.add_KeyDown( (Add-EventWrapper -Method $this.RenameTextBox_KeyDown -SendArgs) )
            # $RenameTextBox.add_Leave( (Add-EventWrapper -Method $this.RenameTextBox_Leave -SendArgs) )
            # $this.Parent.Controls.Add($RenameTextBox)
            # $RenameTextBox.BringToFront()
            # $RenameTextBox.Focus()
            # $RenameTextBox.SelectAll()
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
        # $this.DeleteCategoryButton.Visible = $False
        $CurrentTab = $this.SelectedTab
        $CurrentIndex = $this.SelectedIndex
        $Rect = $this.GetTabRect($CurrentIndex)
        # $RenameTextBox = New-Object TextBox
        # $RenameTextBox.Location = New-Object Point( ($Rect.X + $this.TabControlX), ($Rect.Y + $this.TabControlY) )
        # $RenameTextBox.Size = New-Object Size($Rect.Size)
        # $RenameTextBox.Text = $CurrentTab.Text.Trim()
        # $RenameTextBox.add_KeyDown( (Add-EventWrapper -Method $this.RenameTextBox_KeyDown -SendArgs) )
        # $RenameTextBox.add_Leave( (Add-EventWrapper -Method $this.RenameTextBox_Leave -SendArgs) )
        # $this.MainForm.Controls.Add($RenameTextBox)
        # $RenameTextBox.BringToFront()
        # $RenameTextBox.Focus()
        # $RenameTextBox.SelectAll()
    }
}

# [List[Category]] GetData() {
#     $FileExists = Test-Path -Path $this.SaveDataPath
#     If ($FileExists -eq $False) {
#         $NewCategory = New-Object Category
#         $NewCategory.SetName($this.DefaultCategory)
#         $NewData = [List[Category]]::New()
#         $NewData.Add($NewCategory)
#         $NewData | ConvertTo-Json -Depth 3 | Set-Content -Path $this.SaveDataPath
#     }
#     $RawJSON = Get-Content -Path $this.SaveDataPath -Raw | ConvertFrom-Json
#     $NewData = [List[Category]]::New()
#     foreach ($Object in $RawJSON) {
#         try {
#             $NewCategory = [Category] $Object
#         }
#         catch {
#             $NewCategory = New-Object Category
#             $NewCategory.SetName($Object.Name)
#             foreach ($Task in $Object.TaskList) {
#                 $Task = [Task] $Task
#                 $NewCategory.AddTask($Task)
#             }
#         }
#         finally {
#             $NewData.Add($NewCategory)
#         }
#     }
#     return $NewData
# }

# [TabControl] SetMainTabControl() {
#     foreach ($Category in $this.AgendaData) {
#         $NewTab = New-Object TabPage
#         $NewTab.Text = $Category.GetName()
#         $NewListView = $this.SetListView( ($Category.GetTaskList()) )
#         $NewTab.Controls.Add($NewListView)
#         $NewTab.add_Click( (Add-EventWrapper -Method $this.BlurredControl_Click) )
#         $NewTabControl.Controls.Add($NewTab)
#     }
#     return $NewTabControl
# }

# $this.SaveDataPath = "$($PSScriptRoot)\Save.json"
# $this.IsNew = $False
# $this.AgendaData = $this.GetData()