import Foundation

final class ElevatorController {
	let elevator: Elevator

	init(elevator: Elevator) {
		self.elevator = elevator
	}

	let operationQueue = NSOperationQueue()

	func call(from: Level) {
		let closeDoors = CloseDoorsOperation(elevator: elevator)
		let move = MoveOperation(elevator: elevator, destination: from)
		move.addDependency(closeDoors)
		operationQueue.addOperation(move)
	}
}
