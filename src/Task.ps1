using namespace System.Collections.Generic


class Task {
	[String] $Desc
	[String] $Webpage

	Task() {
		$this.Desc = ""
		$this.Webpage = ""
	}

	[String] GetDesc() {
		return $this.Desc
	}

	[String] GetWebpage() {
		return $this.Webpage
	}

	[Void] SetDesc([String] $NewDesc) {
		$this.Desc = $NewDesc
	}

	[Void] SetWebpage([String] $NewWebpage) {
		$this.Webpage = $NewWebpage
	}
}
