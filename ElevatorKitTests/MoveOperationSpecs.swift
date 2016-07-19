import Quick
import Nimble
@testable import ElevatorKit

class MoveOperationSpecs: QuickSpec {
	override func spec() {
		describe("move operation") {
			let cabin = Cabin(level: 2)
			it("should accept moving to a level lower than the current one") {
				let operation = MoveOperation(cabin: cabin, destination: 0, timeInterval: 0)
				operation.start()
				expect(cabin.currentLevel).toEventually(equal(0))
			}

			it("should accept moving to a level higher than the current one") {
				let operation = MoveOperation(cabin: cabin, destination: 3, timeInterval: 0)
				operation.start()
				expect(cabin.currentLevel).toEventually(equal(3))
			}
		}
	}
}
