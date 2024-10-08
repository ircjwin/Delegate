using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module '..\src\TaskList.ps1'


class AddTaskTextBox: TextBox {
    [int] $AddTaskTextBoxWidth
    [int] $AddTaskTextBoxHeight
    [int] $AddTaskTextBoxX
    [int] $AddTaskTextBoxY

    AddTaskTextBox([Size] $TabControlSize, [Point] $TabControlLocation) {
        $this.AddTaskTextBoxWidth = $TabControlSize.Width - 4
        $this.AddTaskTextBoxHeight = 20
        $this.AddTaskTextBoxX = $TabControlLocation.X + 2
        $this.AddTaskTextBoxY = $TabControlLocation.Y + 30
        $this.Location = New-Object Point( $this.AddTaskTextBoxX, $this.AddTaskTextBoxY )
        $this.Size = New-Object Size( $this.AddTaskTextBoxWidth, $this.AddTaskTextBoxHeight )
        $this.add_KeyDown( (Add-EventWrapper -Method $this.AddTaskTextBox_KeyDown -SendArgs) )
    }

    [Void] AddTaskTextBox_KeyDown([Object] $s, [EventArgs] $e) {
        if ($e.KeyCode -eq "Enter") {
            $MainTabControl = $this.Parent.MainTabControl
            $CurrentTab = $MainTabControl.SelectedTab
            $TaskText = $this.Text
            $CurrentListView = $CurrentTab.Controls[0]
            $CurrentListView.Items.Add($TaskText)
            $CurrentListView.AutoResizeColumn(0, "ColumnContent")
            $this.Clear()
            $e.SuppressKeyPress = $True
            $e.Handled = $True
            foreach ($TaskList in $this.Parent.MainTabControl.TaskListData) {
                if ( ($CurrentTab.Text.Trim()) -eq ($TaskList.GetName()) ) {
                    $NewTask = New-Object Task
                    $NewTask.SetDesc($TaskText)
                    $TaskList.AddTask($NewTask)
                    $this.Parent.IsSaved = $False
                    Break
                }
            }
        }
    }
}
