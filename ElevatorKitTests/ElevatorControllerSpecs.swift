import Quick
import Nimble
@testable import ElevatorKit

class ElevatorControllerSpecs: QuickSpec {
	override func spec() {
		describe("elevator controller") {
			let dataSource = StubElevatorControllerDataSource()
			let elevatorController = ElevatorController(dataSource: dataSource)

			it("should have three door controllers") {
				expect(elevatorController.floorControllers.count).to(equal(3))
			}

			it("should be the delegate of the cabin") {
				let controller = elevatorController as AnyObject
				let cabinDelegate = elevatorController.cabin.delegate as? AnyObject
				expect(controller).to(beIdenticalTo(cabinDelegate))
			}

			it("should be the data source of the cabin panel") {
				let controller = elevatorController
				let panelDataSource = elevatorController.cabinPanel.dataSource as? AnyObject
				expect(controller).to(beIdenticalTo(panelDataSource))
			}

			it("should be the delegate of the cabin panel") {
				let controller = elevatorController
				let panelDelegate = elevatorController.cabinPanel.delegate as? AnyObject
				expect(controller).to(beIdenticalTo(panelDelegate))
			}
		}
	}
}
