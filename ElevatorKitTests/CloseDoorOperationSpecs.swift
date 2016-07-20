import Quick
import Nimble
@testable import ElevatorKit

class CloseDoorOperationSpecs: QuickSpec {
	override func spec() {
		describe("close doors operation") {
			it("should close the doors if the doors are open") {
				let doors = Doors(state: .Open)
				let operation = CloseDoorsOperation(doors: doors, timeInterval: 0)
				operation.start()
				expect(doors.state == Doors.State.Closed).toEventually(beTrue())
			}

			it("should do nothing if the doors are already closed") {
				let doors = Doors(state: .Closed)
				let operation = CloseDoorsOperation(doors: doors, timeInterval: 0)
				operation.start()
				expect(doors.previousStates.count).toEventually(equal(0))
			}
		}
	}
}
