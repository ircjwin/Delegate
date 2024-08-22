using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class ListViewBuilder: ListView {
    [int] $ListViewHeight
    [int] $ListViewWidth
    [int] $ListViewX
    [int] $ListViewY

    ListViewBuilder([int] $TabControlHeight, [int] $TabControlWidth) {
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
    }
}


# [ListView] SetListView([List[Task]] $NewTaskList) {
#     $NewListView = New-Object ListView
#     $NewListView.LabelEdit = $true
#     $NewListView.View = "Details"
#     $NewListView.HeaderStyle = "None"
#     $NewListView.Columns.Add("", -1)
#     $NewListView.CheckBoxes = $True
#     $NewListView.Size = New-Object Size($this.ListViewWidth, $this.ListViewHeight)
#     $NewListView.Location = New-Object Point($this.ListViewX, $this.ListViewY)
#     $NewListView.Font = New-Object Font("Segoe UI", 12, [FontStyle]::Regular)
#     foreach ($Task in $NewTaskList) {
#         $NewListView.Items.Add( ($Task.GetDesc()) )
#     }
#     $NewListView.add_AfterLabelEdit( (Add-EventWrapper -Method $this.ListView_AfterLabelEdit -SendArgs) )
#     return $NewListView
# }

# [Void] ListView_AfterLabelEdit([Object] $s, [EventArgs] $e) {
#     $s.Items[$e.Item].Text = $e.Label.Trim()
#     $s.AutoResizeColumn(0, "ColumnContent")
#     $CurrentTab = $this.MainTabControl.SelectedTab
#     foreach ($Category in $this.AgendaData) {
#         if ( ($CurrentTab.Text.Trim()) -eq ($Category.GetName()) ) {
#             $Category.GetTaskList()[$e.Item].SetDesc($e.Label.Trim())
#             $this.IsSaved = $False
#             Break
#         }
#     }
#     $e.CancelEdit = $true
#     $e.Handled = $true
# }

# $this.ListViewHeight = $this.TabControlHeight - 60
# $this.ListViewWidth = $this.TabControlWidth
# $this.ListViewX = 0
# $this.ListViewY = 32