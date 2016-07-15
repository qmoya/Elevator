import Foundation

class CloseDoorsOperation: NSOperation {
	let elevator: Elevator

	init(elevator: Elevator) {
		self.elevator = elevator
	}

	override func main() {
		elevator.doors.state = .Closing
		NSThread.sleepForTimeInterval(5)
		elevator.doors.state = .Closed
	}
}
