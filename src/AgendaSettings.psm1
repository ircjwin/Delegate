using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Windows.Forms
using namespace System.Drawing


class AgendaSettings {
	[Boolean] $StartupChecked
	[Boolean] $DeployChecked
	[Array] $EngineOptions
	[List[String]] $EngineChoices

	AgendaSettings() {
		$this.StartupChecked = $False
	}

	[Boolean] GetStartupChecked() {
		return $this.StartupChecked
	}

	[Void] SetStartupChecked([Boolean] $NewStatus) {
		$this.StartupChecked = $NewStatus
	}
}