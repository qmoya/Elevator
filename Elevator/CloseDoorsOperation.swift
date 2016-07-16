import Foundation

class CloseDoorsOperation: NSOperation {
	let doors: Doors

	init(doors: Doors) {
		self.doors = doors
	}

	override func main() {
		doors.state = .Closing
		NSThread.sleepForTimeInterval(0.1)
		doors.state = .Closed
	}
}
