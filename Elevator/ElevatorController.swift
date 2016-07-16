import Foundation

public final class ElevatorController {
	public let elevator: Elevator

	let building: Building

	public init(elevator: Elevator, building: Building) {
		self.elevator = elevator
		self.building = building
	}

	let operationQueue = NSOperationQueue()

	public func call(from story: Story) {
		if story == elevator.currentStory && story.doors.state == .Open {
			return
		}
		let closeDoors = CloseDoorsOperation(doors: story.doors)
		let move = MoveOperation(elevator: self.elevator, destination: story, building: building)
		move.addDependency(closeDoors)
		let openDoors = OpenDoorsOperation(doors: story.doors)
		openDoors.addDependency(move)
		operationQueue.addOperation(closeDoors)
		operationQueue.addOperation(move)
		operationQueue.addOperation(openDoors)
	}
}
