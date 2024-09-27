using namespace System.Collections.Generic
using module '.\Task.ps1'


class TaskList {
	[String] $Name
	[List[Task]] $Tasks

	TaskList() {
		$this.Name = ""
		$this.Tasks = [List[Task]]::new()
	}

	[String] GetName() {
		return $this.Name
	}

	[List[Task]] GetTasks() {
		return $this.Tasks
	}

	[Void] SetName([String] $newName) {
		$this.Name = $NewName
	}

	[Void] SetTasks([List[Task]] $NewList) {
		$this.Tasks = $NewList
	}

	[Int] TaskCount() {
		return $this.Tasks.Count
	}

	[Void] AddTask([Task] $NewTask) {
		$this.Tasks.Add($NewTask)
	}

	[Void] RemoveTask([Task] $Task) {
		$this.Tasks.Remove($Task)
	}

	[Void] RemoveTaskAt([Int] $TaskIndex) {
		$this.Tasks.RemoveAt($TaskIndex)
	}

	[Void] ClearTasks() {
		$this.Tasks.Clear()
	}
}
