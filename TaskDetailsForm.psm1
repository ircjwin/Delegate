using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

function Get-DefaultBrowser
{
<#
.SYNOPSIS
	Retrieve user's default browser
.DESCRIPTION
	This function accessess HKEY_CURRENT_USER to retrieve the name of the user's
	default browser. A temporary drive is created at root HKEY_CLASSES_ROOT, and
	the default browser's executable is retrieved and returned.
.NOTES
	This function is adapted from code written by user jkdba on GitHub.
	See LINK for reference.
.LINK
	https://gist.github.com/jkdba/54fd3a3222ee3bae1436028d54634e7a
#>
    $DefaultSettingPath = 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice'
    $DefaultBrowserName = (Get-Item $DefaultSettingPath | Get-ItemProperty).ProgId

    if($DefaultBrowserName -eq 'AppXq0fevzme2pys62n3e0fbqa7peapykr8v')
    {
        $DefaultBrowserPath = 'msedge.exe'
    }
    else
    {
        try
        {
            $null = New-PSDrive -PSProvider registry -Root 'HKEY_CLASSES_ROOT' -Name 'HKCR'
            $DefaultBrowserOpenCommand = (Get-Item "HKCR:\$DefaultBrowserName\shell\open\command" | Get-ItemProperty).'(default)'
            $DefaultBrowserPath = [regex]::Match($DefaultBrowserOpenCommand,'\".+?\"')
        }
        catch
        {
            Throw $_.Exception
        }
        finally
        {
            Remove-PSDrive -Name 'HKCR'
        }
    }
	return $DefaultBrowserPath
}

[Form] SetTaskDetailsForm() {
    $NewForm = New-Object Form
    $NewForm.StartPosition = [FormStartPosition]::CenterParent
    $NewForm.Size = New-Object Size(200, 100)
    $NewForm.Text = "Task Details"

    $NewLabel = New-Object Label
    $this.WebpageTextBox = New-Object TextBox
    $NewCloseButton = New-Object Button
    $NewForm.Size = New-Object Size(400, 200)
    $NewLabel.Width = 200
    $this.WebpageTextBox.Width = 370
    $NewLabel.Height = 18
    $NewForm.Location = New-Object Point(0, 0)
    $NewLabel.Location = New-Object Point(10, 63)
    $this.WebpageTextBox.Location = New-Object Point(10, 83)
    $NewCloseButton.Location = New-Object Point(170, 113)
    $NewForm.Text = "Task Details"
    $NewLabel.Text = "Webpages:"
    $NewCloseButton.Text = "Close"
    $NewForm.Controls.AddRange( @($NewLabel, $this.WebpageTextBox) )
    return $NewForm
}
