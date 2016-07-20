import Quick
import Nimble
@testable import ElevatorKit

class CabinPanelSpecs: QuickSpec {
	override func spec() {
		describe("cabin panel") {
			it("should call the delegate when a destination is selected") {
				let panel = CabinPanel()
				let delegate = MockCabinPanelDelegate()
				panel.delegate = delegate
				panel.call(levelAtIndex: 1)
				expect(delegate.state.level).to(equal(1))
			}

			it("shouldn't display anything without a data source") {
				let panel = CabinPanel()
				panel.reloadData()
				expect(panel.displayedText).to(equal(""))
			}
		}
	}
}
