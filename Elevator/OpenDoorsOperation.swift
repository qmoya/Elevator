import Foundation

class OpenDoorsOperation: NSOperation {
	let elevator: Elevator

	init(elevator: Elevator) {
		self.elevator = elevator
	}

	override func main() {
		elevator.doors.state = .Opening
		NSThread.sleepForTimeInterval(5)
		elevator.doors.state = .Open
	}
}
