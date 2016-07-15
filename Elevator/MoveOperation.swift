import Foundation

class MoveOperation: NSOperation {
	let elevator: Elevator

	let destination: Level

	init(elevator: Elevator, destination: Level) {
		self.elevator = elevator
		self.destination = destination
	}

	override func main() {
		for level in elevator.currentLevel...destination {
			NSThread.sleepForTimeInterval(10)
			elevator.state = .Moving(level)
		}
	}
}
