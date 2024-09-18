using module '.\TaskList.psm1'

$SaveDataPath = "$($PSScriptRoot)\Save.json"

function Get-TaskListData {
    param (
        [Parameter()]
        [String] $DefaultName
    )
    $FileExists = Test-Path -Path $SaveDataPath
    If ($FileExists -eq $False) {
        $NewTaskList = New-Object TaskList
        $NewTaskList.SetName($DefaultName)
        $NewData = [List[TaskList]]::New()
        $NewData.Add($NewTaskList)
        $NewData | ConvertTo-Json -Depth 3 | Set-Content -Path $SaveDataPath
    }
    $RawJSON = Get-Content -Path $SaveDataPath -Raw | ConvertFrom-Json
    $NewData = [List[TaskList]]::New()
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