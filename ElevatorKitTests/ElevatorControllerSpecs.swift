import Quick
import Nimble
@testable import ElevatorKit

class ElevatorControllerSpecs: QuickSpec {
	override func spec() {
		describe("elevator controller") {
			let cabin = Cabin(level: 0)
			let dataSource = TestElevatorControllerDataSource()
			let elevatorController = ElevatorController(cabin: cabin, dataSource: dataSource)

			it("should have three door controllers") {
				expect(elevatorController.floorControllers.count).to(equal(3))
			}

			it("should be the delegate of the cabin") {
				let controller = elevatorController as AnyObject
				let cabinDelegate = cabin.delegate as! AnyObject
				expect(controller).to(beIdenticalTo(cabinDelegate))
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
}
