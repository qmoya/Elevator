import Foundation

class OpenDoorsOperation: NSOperation {
	internal let doors: Doors

	internal let timeInterval: NSTimeInterval

	init(doors: Doors, timeInterval: NSTimeInterval) {
		self.doors = doors
		self.timeInterval = timeInterval
	}

	override func main() {
		if doors.state == .Open {
			return
		}
		doors.state = .Opening
		NSThread.sleepForTimeInterval(timeInterval)
		doors.state = .Open
	}
}
