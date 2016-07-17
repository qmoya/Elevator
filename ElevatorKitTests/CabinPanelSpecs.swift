import Quick
import Nimble
@testable import ElevatorKit

class CabinPanelSpecs: QuickSpec {
	override func spec() {
		describe("cabin panel") {
			it("should call the delegate when a destination is selected") {
				let panel = CabinPanel()
				let delegate = TestCabinPanelDelegate()
				panel.delegate = delegate
				panel.call(1)
				expect(delegate.state.level).to(equal(1))
			}

			it("should have the right number of levels") {
				let panel = CabinPanel()
				let dataSource = TestCabinPanelDataSource(numberOfLevels: 8, displayedText: "works")
				panel.dataSource = dataSource
				panel.reloadData()
				expect(panel.numberOfLevels).to(equal(8))
			}

			it("shouldn't display anything without a data source") {
				let panel = CabinPanel()
				panel.reloadData()
				expect(panel.displayedText).to(equal(""))
			}
		}
	}
}

private class TestCabinPanelDelegate: CabinPanelDelegate {
	enum State {
		case NotCalled
		case Called(Level)

		var level: Level? {
			switch self {
			case .NotCalled:
				return nil
			case .Called(let level):
				return level
			}
		}
	}

	var state: State = .NotCalled

	func cabinPanel(cabinPanel: CabinPanel, didCallLevel level: Level) {
		state = .Called(level)
	}
}

private class TestCabinPanelDataSource: CabinPanelDataSource {
	let numberOfLevels: Int
	let displayedText: String

	init(numberOfLevels: Int, displayedText: String) {
		self.numberOfLevels = numberOfLevels
		self.displayedText = displayedText
	}

	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int {
		return numberOfLevels
	}

	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String {
		return displayedText
	}

}
