import Foundation

internal class MoveOperation: NSOperation {
	internal let cabin: Cabin

	internal let destination: Level

	internal let timeInterval: NSTimeInterval

	internal init(cabin: Cabin, destination: Level, timeInterval: NSTimeInterval) {
		self.cabin = cabin
		self.destination = destination
		self.timeInterval = timeInterval
	}

	internal override func main() {
		let delta = cabin.currentLevel < destination ? 1 : -1
		let stride = cabin.currentLevel.stride(to: destination + delta, by: delta)
		for level in stride {
			NSThread.sleepForTimeInterval(timeInterval)
			if delta > 0 {
				cabin.state = .MovingUp(level)
			} else {
				cabin.state = .MovingDown(level)
			}
		}
		cabin.state = .Stopped(destination)
	}
}
