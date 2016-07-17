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
		for level in cabin.currentLevel.stride(to: destination, by: delta) {
			NSThread.sleepForTimeInterval(0.1)
			cabin.state = .Moving(level)
		}
		cabin.state = .Stopped(destination)
	}
}
