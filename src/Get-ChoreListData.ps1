using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing

using module '.\Chore.ps1'
using module '.\ChoreList.ps1'


function Get-ChoreListData {
    param (
        [Parameter()]
        [String] $DefaultName
    )
    $SaveDataPath = "$($PSScriptRoot)\Save.json"
    $FileExists = Test-Path -Path $SaveDataPath
    If ($FileExists -eq $False) {
        $NewChoreList = New-Object ChoreList
        $NewChoreList.SetName($DefaultName)
        $NewData = [List[ChoreList]]::new()
        $NewData.Add($NewChoreList)
        $NewData | ConvertTo-Json -Depth 3 | Set-Content -Path $SaveDataPath
    }
    $RawJSON = Get-Content -Path $SaveDataPath -Raw | ConvertFrom-Json
    $NewData = [List[ChoreList]]::new()
    foreach ($Object in $RawJSON) {
        try {
            $NewChoreList = [ChoreList] $Object
        }
        catch {
            $NewChoreList = New-Object ChoreList
            $NewChoreList.SetName($Object.Name)
            foreach ($Chore in $Object.Chores) {
                $Chore = [Chore] $Chore
                $NewChoreList.AddChore($Chore)
            }
        }
        finally {
            $NewData.Add($NewChoreList)
        }
    }
    return $NewData
}
