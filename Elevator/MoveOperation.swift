import Foundation

internal class MoveOperation: NSOperation {
	internal let cabin: Cabin

	internal let destination: Level

	internal init(cabin: Cabin, destination: Level) {
		self.cabin = cabin
		self.destination = destination
	}

	internal override func main() {
		let delta = cabin.currentLevel < destination ? 1 : -1
		let stride = cabin.currentLevel.stride(to: destination, by: delta)
		for level in stride {
			NSThread.sleepForTimeInterval(0.1)
			cabin.state = .Moving(level)
		}
		cabin.state = .Stopped(destination)
	}
}
