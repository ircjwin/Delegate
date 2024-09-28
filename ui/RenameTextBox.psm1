using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module '..\src\ChoreList.ps1'
class RenameTextBox: TextBox {
    [String] $InvalidNameTitle
    [String] $InvalidNameMsg
    [String] $DuplicateNameTitle
    [String] $DuplicateNameMsg

    RenameTextBox() {
        $this.InvalidNameTitle = "Invalid Name"
        $this.InvalidNameMsg = "Please enter a valid name."
        $this.DuplicateNameTitle = "Duplicate Name"
        $this.DuplicateNameMsg = "Name already in use."
        $this.add_KeyDown( (Add-EventWrapper -Method $this.RenameTextBox_KeyDown -SendArgs) )
        $this.add_Leave( (Add-EventWrapper -Method $this.RenameTextBox_Leave -SendArgs) )
    }

    [Void] RenameTextBox_KeyDown([Object] $s, [EventArgs] $e) {
        if ($e.KeyCode -ne "Enter") {
            return
        }
        $e.Handled = $True
        $e.SuppressKeyPress = $True
        $NewChoreListName = $s.Text.Trim()
        if ($NewChoreListName -eq "") {
            $MsgBtns = [MessageBoxButtons]::OK
            [MessageBox]::Show($this.InvalidNameMsg, $this.InvalidNameTitle, $MsgBtns)
            return
        }
        foreach ($ChoreList in $this.Parent.MainTabControl.ChoreListData) {
            if ( ($ChoreList.GetName()) -eq $NewChoreListName) {
                $MsgBtns = [MessageBoxButtons]::OK
                [MessageBox]::Show($this.DuplicateNameMsg, $this.DuplicateNameTitle, $MsgBtns)
                return
            }
        }
        if ($this.Parent.MainTabControl.IsNew -eq $True) {
            $NewChoreList = New-Object ChoreList
            $this.Parent.MainTabControl.ChoreListData.Add($NewChoreList)
            $this.Parent.MainTabControl.IsNew = $False
        }
        $CurrentIndex = $this.Parent.MainTabControl.SelectedIndex
        $this.Parent.MainTabControl.ChoreListData[$CurrentIndex].SetName($NewChoreListName)
        $this.Parent.MainTabControl.SelectedTab.Text = $NewChoreListName + $this.Parent.MainTabControl.SelectedTabWhitespace
        $this.Parent.DeleteChoreListButton.Relocate()
        $this.Parent.DeleteChoreListButton.Visible = $True
        $this.Parent.IsSaved = $False
        $s.Dispose()
    }

    [Void] RenameTextBox_Leave([Object] $s, [EventArgs] $e) {
        if ($s.Disposing -eq $True) {
            return
        }
        if ($this.Parent.MainTabControl.IsNew -eq $True) {
            $CurrentTab = $this.Parent.MainTabControl.SelectedTab
            $DefaultName = $CurrentTab.Text.Trim()
            $NewChoreListName = -Split $DefaultName
            $MaxUnnamedCount = 0
            foreach ($ChoreList in $this.Parent.MainTabControl.ChoreListData) {
                $ChoreListName = -Split ( $ChoreList.GetName() )
                if ($ChoreListName.Count -lt 2 -or $ChoreListName.Count -gt 3) {
                    Continue
                }
                if ($ChoreListName[0] -eq $NewChoreListName[0] -and $ChoreListName[1] -eq $NewChoreListName[1]) {
                    if ($ChoreListName.Count -eq 3) {
                        $Num = $ChoreListName[2] -as [Int]
                        if ($Null -eq $Num) {
                            Continue
                        }
                        if ($Num -ge $MaxUnnamedCount) {
                            $MaxUnnamedCount = $Num + 1
                        }
                    } else {
                        if ($MaxUnnamedCount -eq 0) {
                            $MaxUnnamedCount = 1
                        }
                    }
                }
            }
            if ($MaxUnnamedCount-gt 0) {
                $DefaultName = "$($DefaultName) $($MaxUnnamedCount)"
                $CurrentTab.Text = $DefaultName + $this.Parent.MainTabControl.SelectedTabWhitespace
            }
            $this.Parent.DeleteChoreListButton.Relocate()
            $NewChoreList = New-Object ChoreList
            $NewChoreList.SetName($DefaultName)
            $this.Parent.MainTabControl.ChoreListData.Add($NewChoreList)
            $this.Parent.IsSaved = $False
            $this.Parent.MainTabControl.IsNew = $False
        }
        $this.Parent.DeleteChoreListButton.Visible = $True
        $s.Dispose()
    }
}
