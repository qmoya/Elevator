import Quick
import Nimble
@testable import ElevatorKit

class OpenDoorsOperationSpecs: QuickSpec {
	override func spec() {
		describe("open doors operation") {
			it("should open the doors if the doors are closed") {
				let doors = Doors(state: .Closed)
				let operation = OpenDoorsOperation(doors: doors, timeInterval: 0)
				operation.start()
				expect(doors.state == Doors.State.Open).toEventually(beTrue())
			}

			it("should do nothing if the doors are already open") {
				let doors = Doors(state: .Open)
				let operation = OpenDoorsOperation(doors: doors, timeInterval: 0)
				operation.start()
				expect(doors.previousStates.count).toEventually(equal(0))
			}
		}
	}
}
