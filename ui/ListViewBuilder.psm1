using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class ListViewBuilder: ListView {
    [int] $ListViewHeight
    [int] $ListViewWidth
    [int] $ListViewX
    [int] $ListViewY

    ListViewBuilder([int] $TabControlHeight, [int] $TabControlWidth, [List[string]] $TaskDescList) {
        $this.ListViewHeight = $TabControlHeight - 60
        $this.ListViewWidth = $TabControlWidth
        $this.ListViewX = 0
        $this.ListViewY = 32
        $this.Size = New-Object Size($this.ListViewWidth, $this.ListViewHeight)
        $this.Location = New-Object Point($this.ListViewX, $this.ListViewY)
        $this.LabelEdit = $true
        $this.View = "Details"
        $this.HeaderStyle = "None"
        $this.Columns.Add("", -1)
        $this.CheckBoxes = $True
        $this.Font = New-Object Font("Segoe UI", 12, [FontStyle]::Regular)
        if ($TaskDescList) {
            $this.Items.AddRange($TaskDescList)
        }
        $this.add_AfterLabelEdit( (Add-EventWrapper -Method $this.ListView_AfterLabelEdit -SendArgs) )
    }

    [Void] ListView_AfterLabelEdit([Object] $s, [EventArgs] $e) {
        if (!$e.Label) {
            return
        }
        $s.Items[$e.Item].Text = $e.Label.Trim()
        $s.AutoResizeColumn(0, "ColumnContent")
        $CurrentTab = $this.Parent.Parent.SelectedTab
        foreach ($TaskList in $this.Parent.Parent.TaskListData) {
            if ( ($CurrentTab.Text.Trim()) -eq ($TaskList.GetName()) ) {
                $TaskList.GetTasks()[$e.Item].SetDesc($e.Label.Trim())
                $this.Parent.Parent.Parent.IsSaved = $False
                Break
            }
        }
    }
}
