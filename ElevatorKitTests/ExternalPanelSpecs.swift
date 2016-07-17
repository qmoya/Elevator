import Quick
import Nimble
@testable import ElevatorKit

class ExternalPanelSpecs: QuickSpec {
	override func spec() {
		describe("close doors operation") {
			it("should call the delegate when the elevator is called") {
				let panel = ExternalPanel()
				let delegate = TestExternalPanelDelegate()
				panel.delegate = delegate
				panel.call()
				expect(delegate.externalPanelDidCallWasCalled).to(beTrue())
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
