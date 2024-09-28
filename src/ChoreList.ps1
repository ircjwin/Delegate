using namespace System.Collections.Generic
using module '.\Chore.ps1'


class ChoreList {
	[String] $Name
	[List[Chore]] $Chores

	ChoreList() {
		$this.Name = ""
		$this.Chores = [List[Chore]]::new()
	}

	[String] GetName() {
		return $this.Name
	}

	[List[Chore]] GetChores() {
		return $this.Chores
	}

	[Void] SetName([String] $newName) {
		$this.Name = $NewName
	}

	[Void] SetChores([List[Chore]] $NewList) {
		$this.Chores = $NewList
	}

	[Int] ChoreCount() {
		return $this.Chores.Count
	}

	[Void] AddChore([Chore] $NewChore) {
		$this.Chores.Add($NewChore)
	}

	[Void] RemoveChore([Chore] $Chore) {
		$this.Chores.Remove($Chore)
	}

	[Void] RemoveChoreAt([Int] $ChoreIndex) {
		$this.Chores.RemoveAt($ChoreIndex)
	}

	[Void] ClearChores() {
		$this.Chores.Clear()
	}
}
