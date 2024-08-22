[Void] RenameTextBox_KeyDown([Object] $s, [EventArgs] $e) {
    if ($e.KeyCode -ne "Enter") {
        return
    }
    $e.Handled = $True
    $e.SuppressKeyPress = $True
    $NewCategoryName = $s.Text.Trim()
    if ($NewCategoryName -eq "") {
        $MsgBtns = [MessageBoxButtons]::OK
        [MessageBox]::Show($this.InvalidNameMsg, $this.InvalidNameTitle, $MsgBtns)
        return
    }
    foreach ($Category in $this.AgendaData) {
        if ( ($Category.GetName()) -eq $NewCategoryName) {
            $MsgBtns = [MessageBoxButtons]::OK
            [MessageBox]::Show($this.DuplicateNameMsg, $this.DuplicateNameTitle, $MsgBtns)
            return
        }
    }
    if ($this.IsNew -eq $True) {
        $NewCategory = New-Object Category
        $this.AgendaData.Add($NewCategory)
        $this.IsNew = $False
    }
    $s.Dispose()
    $CurrentIndex = $this.MainTabControl.SelectedIndex
    $this.AgendaData[$CurrentIndex].SetName($NewCategoryName)
    $this.MainTabControl.SelectedTab.Text = $NewCategoryName + $this.SelectedTabWhitespace
    $this.RelocateDeleteCategoryButton()
    $this.DeleteCategoryButton.Visible = $True
    $this.IsSaved = $False
}

[Void] RenameTextBox_Leave([Object] $s, [EventArgs] $e) {
    if ($s.Disposing -eq $True) {
        return
    }
    if ($this.IsNew -eq $True) {
        $CurrentTab = $this.MainTabControl.SelectedTab
        $DefaultName = $CurrentTab.Text.Trim()
        $NewCategoryName = -Split $DefaultName
        $MaxUnnamedCount = 0
        foreach ($Category in $this.AgendaData) {
            $CategoryName = -Split ( $Category.GetName() )
            if ($CategoryName.Count -lt 2 -or $CategoryName.Count -gt 3) {
                Continue
            }
            if ($CategoryName[0] -eq $NewCategoryName[0] -and $CategoryName[1] -eq $NewCategoryName[1]) {
                if ($CategoryName.Count -eq 3) {
                    $Num = $CategoryName[2] -as [Int]
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
            $CurrentTab.Text = $DefaultName + $this.SelectedTabWhitespace
        }
        $this.RelocateDeleteCategoryButton()
        $NewCategory = New-Object Category
        $NewCategory.SetName($DefaultName)
        $this.AgendaData.Add($NewCategory)
        $this.IsSaved = $False
        $this.IsNew = $False
    }
    $s.Dispose()
    $this.DeleteCategoryButton.Visible = $True
}

$this.InvalidNameTitle = "Invalid Name"
$this.InvalidNameMsg = "Please enter a valid name."
$this.DuplicateNameTitle = "Duplicate Name"
$this.DuplicateNameMsg = "Name already in use."