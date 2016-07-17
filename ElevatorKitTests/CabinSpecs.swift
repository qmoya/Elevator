import Quick
import Nimble
@testable import ElevatorKit

class CabinSpecs: QuickSpec {
	override func spec() {
		describe("cabin") {
			let cabin = Cabin(level: 1)

			it("should be initially stopped at the specified level") {
				expect(cabin.currentLevel).to(equal(1))
			}

			context("an invalid level is specified") {
				let delegate = TestCabinDelegate(numberOfStories: 3)
				cabin.delegate = delegate
				let invalidLevel = 3

				it("should throw an error") {
					expect {try cabin.state = .Stopped(invalidLevel)}.to(throwError())
				}
			}
		}
	}
}

class TestCabinDelegate: CabinDelegate {
	var cabinDidChangeStateWasCalled = false

	let numberOfStories: Int

	init(numberOfStories: Int) {
		self.numberOfStories = numberOfStories
	}

	func cabinShouldMoveToLevel(level: Level) -> Bool {
		return level < numberOfStories
	}

	func cabinDidChangeState(cabin: Cabin) {
		cabinDidChangeStateWasCalled = true
	}
}
