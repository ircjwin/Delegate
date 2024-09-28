using namespace System.Collections.Generic


class Chore {
	[String] $Desc
	[String] $Webpage

	Chore() {
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
