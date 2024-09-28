using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module '..\src\ChoreList.ps1'


class AddChoreTextBox: TextBox {
    [int] $AddChoreTextBoxWidth
    [int] $AddChoreTextBoxHeight
    [int] $AddChoreTextBoxX
    [int] $AddChoreTextBoxY

    AddChoreTextBox([Size] $TabControlSize, [Point] $TabControlLocation) {
        $this.AddChoreTextBoxWidth = $TabControlSize.Width - 4
        $this.AddChoreTextBoxHeight = 20
        $this.AddChoreTextBoxX = $TabControlLocation.X + 2
        $this.AddChoreTextBoxY = $TabControlLocation.Y + 30
        $this.Location = New-Object Point( $this.AddChoreTextBoxX, $this.AddChoreTextBoxY )
        $this.Size = New-Object Size( $this.AddChoreTextBoxWidth, $this.AddChoreTextBoxHeight )
        $this.add_KeyDown( (Add-EventWrapper -Method $this.AddChoreTextBox_KeyDown -SendArgs) )
    }

    [Void] AddChoreTextBox_KeyDown([Object] $s, [EventArgs] $e) {
        if ($e.KeyCode -eq "Enter") {
            $MainTabControl = $this.Parent.MainTabControl
            $CurrentTab = $MainTabControl.SelectedTab
            $ChoreText = $this.Text
            $CurrentListView = $CurrentTab.Controls[0]
            $CurrentListView.Items.Add($ChoreText)
            $CurrentListView.AutoResizeColumn(0, "ColumnContent")
            $this.Clear()
            $e.SuppressKeyPress = $True
            $e.Handled = $True
            foreach ($ChoreList in $this.Parent.MainTabControl.ChoreListData) {
                if ( ($CurrentTab.Text.Trim()) -eq ($ChoreList.GetName()) ) {
                    $NewChore = New-Object Chore
                    $NewChore.SetDesc($ChoreText)
                    $ChoreList.AddChore($NewChore)
                    $this.Parent.IsSaved = $False
                    Break
                }
            }
        }
    }
}
