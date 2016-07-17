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
				expect(elevatorController.doorControllers.count).to(equal(3))
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
		return Doors()
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

//class ElevatorControllerSpecs: QuickSpec {
//
//	override func spec() {
//		var controller: ElevatorController!
//
//		describe("elevator controller") {
//
//			context("at the second floor") {
//				context("elevator at second floor") {
//					controller = ElevatorController()
//					controller.elevator.state = Elevator.State.Stopped(controller.building.stories[2])
//
//					context("doors open") {
//						it("pressing the button should do nothing") {
//							controller.call(from: controller.building.stories[1])
//							expect(controller.building.stories[1].doors.state).to(equal(Doors.State.Open))
//							expect(controller.elevator.history).to(haveCount(1))
//						}
//					}
//
//					context("doors closed") {
//						controller.building.stories[1].doors.state = .Closed
//
//						it("pressing the button should open the doors") {
//							controller.call(from: controller.building.stories[1])
//							expect(controller.building.stories[1].doors.state).toEventually(equal(Doors.State.Open))
//							expect(controller.elevator.history).to(haveCount(1))
//						}
//					}
//				}
//
//				context("elevator at third floor") {
//					beforeEach {
//						controller = ElevatorController()
//						controller.elevator.state = Elevator.State.Stopped(controller.building.stories[2])
//					}
//
//					context("doors open") {
//						beforeEach {
//							story.doors.state = .Open
//						}
//
//						it("pressing the button should move down the elevator") {
//							controller.call(from: story)
//							expect(controller.elevator.history).toEventually(equal([
//								Elevator.State.Stopped(controller.building.stories[2]),
//								Elevator.State.Stopped(controller.building.stories[1]),
//							]))
//							expect(story.doors.state).toEventually(equal(Doors.State.Open))
//						}
//					}
//
//					context("doors closed") {
//						beforeEach {
//							story.doors.state = .Closed
//						}
//
//						it("pressing the button should open the doors") {
//							controller.call(from: story)
//							expect(story.doors.state).toEventually(equal(Doors.State.Open))
//							expect(controller.elevator.history).to(haveCount(1))
//						}
//					}
//				}
//			}
//		}
//	}
//}
//
//extension ElevatorController {
//	convenience init() {
//		let building = Building(stories: [
//			Story(name: "First", abbreviation: "1"),
//			Story(name: "Second", abbreviation: "2"),
//			Story(name: "Third", abbreviation: "3")
//			])
//		let elevator = Elevator(story: building.stories[1])
//		self.init(cabin: elevator, building: building)
//	}
//}
