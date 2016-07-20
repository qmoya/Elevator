import Foundation

internal class CloseDoorsOperation: NSOperation {
	internal let doors: Doors

	internal let timeInterval: NSTimeInterval

	init(doors: Doors, timeInterval: NSTimeInterval) {
		self.doors = doors
		self.timeInterval = timeInterval
	}

	override func main() {
		if doors.state == .Closed {
			return
		}
		doors.state = .Closing
		NSThread.sleepForTimeInterval(0.1)
		doors.state = .Closed
	}
}
