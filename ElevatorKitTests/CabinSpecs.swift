import Quick
import Nimble
@testable import ElevatorKit

class CabinSpecs: QuickSpec {
	override func spec() {
		describe("cabin") {
			it("should be initially stopped at the specified level") {
				let cabin = Cabin(level: 1)
				expect(cabin.currentLevel).to(equal(1))
			}

			it("should call the right delegate method when state is changed") {
				let cabin = Cabin(level: 0)
				let delegate = TestCabinDelegate()
				cabin.delegate = delegate
				cabin.state = .MovingUp(3)
				expect(delegate.cabinDidChangeStateWasCalled).toEventually(beTrue())
			}

			it("should not the right delegate method when state is changed") {
				let cabin = Cabin(level: 2)
				let delegate = TestCabinDelegate()
				cabin.delegate = delegate
				cabin.state = .Stopped(2)
				expect(delegate.cabinDidChangeStateWasCalled).to(beFalse())
			}

			context("when it’s moving") {
				let cabin = Cabin(level: 0)
				cabin.state = .MovingUp(5)

				it("should have the correct current level") {
					expect(cabin.currentLevel).to(equal(5))
				}
			}

			context("when it’s stopped") {
				let cabin = Cabin(level: 0)
				cabin.state = .Stopped(4)

				it("should have the correct current level") {
					expect(cabin.currentLevel).to(equal(4))
				}
			}
		}

		describe("cabin states") {
			it("should be different when one is moving and the other one stopped") {
				expect(Cabin.State.MovingUp(1)).toNot(equal(Cabin.State.Stopped(1)))
			}

			it("should be different when both are moving but in different levels") {
				expect(Cabin.State.MovingUp(1)).toNot(equal(Cabin.State.MovingUp(2)))
			}

			it("should be different when both are stopped but in different levels") {
				expect(Cabin.State.Stopped(1)).toNot(equal(Cabin.State.Stopped(2)))
			}

			it("should be different when both are moving in the same levels") {
				expect(Cabin.State.MovingUp(1)).to(equal(Cabin.State.MovingUp(1)))
			}

			it("should be different when both are moving in the same levels") {
				expect(Cabin.State.Stopped(1)).to(equal(Cabin.State.Stopped(1)))
			}
		}
	}
}
