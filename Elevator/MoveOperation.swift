import Foundation

class MoveOperation: NSOperation {
	let cabin: Cabin

	let destination: Level

	init(cabin: Cabin, destination: Level) {
		self.cabin = cabin
		self.destination = destination
	}

	override func main() {
		for level in cabin.currentLevel...destination {
			NSThread.sleepForTimeInterval(0.1)
			cabin.state = .Moving(level)
		}
		cabin.state = .Stopped(destination)
	}
}
