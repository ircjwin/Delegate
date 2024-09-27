using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module '.\Task.ps1'
using module '.\TaskList.ps1'


function Get-TaskListData {
    param (
        [Parameter()]
        [String] $DefaultName
    )
    $SaveDataPath = "$($PSScriptRoot)\Save.json"
    $FileExists = Test-Path -Path $SaveDataPath
    If ($FileExists -eq $False) {
        $NewTaskList = New-Object TaskList
        $NewTaskList.SetName($DefaultName)
        $NewData = [List[TaskList]]::new()
        $NewData.Add($NewTaskList)
        $NewData | ConvertTo-Json -Depth 3 | Set-Content -Path $SaveDataPath
    }
    $RawJSON = Get-Content -Path $SaveDataPath -Raw | ConvertFrom-Json
    $NewData = [List[TaskList]]::new()
    foreach ($Object in $RawJSON) {
        try {
            $NewTaskList = [TaskList] $Object
        }
        catch {
            $NewTaskList = New-Object TaskList
            $NewTaskList.SetName($Object.Name)
            foreach ($Task in $Object.Tasks) {
                $Task = [Task] $Task
                $NewTaskList.AddTask($Task)
            }
        }
        finally {
            $NewData.Add($NewTaskList)
        }
    }
    return $NewData
}
