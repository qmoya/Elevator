import Foundation

class OpenDoorsOperation: NSOperation {
	let doors: Doors

	init(doors: Doors) {
		self.doors = doors
	}

	override func main() {
		if doors.state == .Open {
			return
		}
		doors.state = .Opening
		NSThread.sleepForTimeInterval(0.1)
		doors.state = .Open
	}
}
