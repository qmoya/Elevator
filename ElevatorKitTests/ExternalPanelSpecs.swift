import Quick
import Nimble
@testable import ElevatorKit

class ExternalPanelSpecs: QuickSpec {
	override func spec() {
		describe("external panel") {
			it("should call the delegate when the elevator is called") {
				let panel = ExternalPanel()
				let delegate = TestExternalPanelDelegate()
				panel.delegate = delegate
				panel.call()
				expect(delegate.externalPanelDidCallWasCalled).to(beTrue())
			}

			it("should set the right text") {
				let panel = ExternalPanel()
				let dataSource = TestExternalPanelDataSource(displayedText: "works")
				panel.dataSource = dataSource
				panel.reloadData()
				expect(panel.displayedText).to(equal("works"))
			}
			
			it("shouldn't display anything without a data source") {
				let panel = ExternalPanel()
				panel.reloadData()
				expect(panel.displayedText).to(equal(""))
			}
		}
	}
}

class TestExternalPanelDelegate: ExternalPanelDelegate {
	var externalPanelDidCallWasCalled = false
	func externalPanelDidCall(externalPanel: ExternalPanel) {
		externalPanelDidCallWasCalled = true
	}
}

class TestExternalPanelDataSource: ExternalPanelDataSource {
	let displayedText: String

	init(displayedText: String) {
		self.displayedText = displayedText
	}

	func displayedTextForExternalPanel(externalPanel: ExternalPanel) -> String {
		return displayedText
	}
}
