using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class TaskDetailsForm: Form {
    TaskDetailsForm() {
        $this.StartPosition = [FormStartPosition]::CenterParent
        $this.Size = New-Object Size(400, 200)
        $this.Location = New-Object Point(0, 0)
        $this.Text = "Task Details"

        $NewLabel = New-Object Label
        $NewLabel.Width = 200
        $NewLabel.Height = 18
        $NewLabel.Location = New-Object Point(10, 63)
        $NewLabel.Text = "Webpages:"

        $WebpageTextBox = New-Object TextBox
        $WebpageTextBox.Width = 370
        $WebpageTextBox.Location = New-Object Point(10, 83)

        $NewCloseButton = New-Object Button
        $NewCloseButton.Location = New-Object Point(170, 113)
        $NewCloseButton.Text = "Close"

        $this.Controls.AddRange( @($NewLabel, $WebpageTextBox) )
    }
}
