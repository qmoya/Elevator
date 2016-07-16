import Foundation

class MoveOperation: NSOperation {
	let elevator: Elevator

	let destination: Story

	let building: Building

	init(elevator: Elevator, destination: Story, building: Building) {
		self.elevator = elevator
		self.destination = destination
		self.building = building
	}

	override func main() {
		for level in building.storiesBetween(elevator.currentStory, destination: destination) {
			NSThread.sleepForTimeInterval(0.1)
			elevator.state = .Moving(level)
		}
		elevator.state = .Stopped(destination)
	}
}
