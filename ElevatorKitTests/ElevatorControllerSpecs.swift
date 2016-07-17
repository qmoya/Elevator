import Quick
import Nimble
@testable import ElevatorKit

class ElevatorControllerSpecs: QuickSpec {
	override func spec() {
		describe("elevator controller") {
			let dataSource = TestElevatorControllerDataSource()
			let elevatorController = ElevatorController(dataSource: dataSource)

			it("should have three door controllers") {
				expect(elevatorController.floorControllers.count).to(equal(3))
			}

			it("should be the delegate of the cabin") {
				let controller = elevatorController as AnyObject
				let cabinDelegate = elevatorController.cabin.delegate as! AnyObject
				expect(controller).to(beIdenticalTo(cabinDelegate))
			}

			it("should be the data source of the cabin panel") {
				let controller = elevatorController
				let panelDataSource = elevatorController.cabinPanel.dataSource as! AnyObject
				expect(controller).to(beIdenticalTo(panelDataSource))
			}

			it("should be the delegate of the cabin panel") {
				let controller = elevatorController
				let panelDelegate = elevatorController.cabinPanel.delegate as! AnyObject
				expect(controller).to(beIdenticalTo(panelDelegate))
			}
		}
	}
}

class TestElevatorControllerDataSource: ElevatorControllerDataSource {
	func elevatorController(elevatorController: ElevatorController, doorsForLevel level: Level) -> Doors {
		return Doors(state: .Closed)
	}

	func elevatorController(elevatorController: ElevatorController, abbreviationForLevel level: Level) -> String {
		return ""
	}

	func elevatorController(elevatorController: ElevatorController, panelForLevel level: Level) -> ExternalPanel {
		return ExternalPanel()
	}

	func numberOfLevelsForElevatorController(elevatorController: ElevatorController) -> Int {
		return 3
	}

	func cabinPanelForElevatorController(elevatorController: ElevatorController) -> CabinPanel {
		return CabinPanel()
	}

	func cabinForElevatorController(elevatorController: ElevatorController) -> Cabin {
		return Cabin(level: 0)
	}
}
