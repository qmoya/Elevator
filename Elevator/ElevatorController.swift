public typealias Level = Int

public protocol ElevatorControllerDataSource {
	func elevatorController(elevatorController: ElevatorController, abbreviationForLevel level: Level) -> String
	func numberOfLevelsForElevatorController(elevatorController: ElevatorController) -> Int
	func elevatorController(elevatorController: ElevatorController, doorsForLevel level: Level) -> Doors
	func elevatorController(elevatorController: ElevatorController, panelForLevel level: Level) -> ExternalPanel
}

public final class ElevatorController {
	public let cabin: Cabin

	public let dataSource: ElevatorControllerDataSource

	public init(cabin: Cabin, dataSource: ElevatorControllerDataSource) {
		self.cabin = cabin
		self.dataSource = dataSource
		cabin.delegate = self
		loadDoorControllers()
	}

	internal var doorControllers = [DoorController]()

	internal let operationQueue = NSOperationQueue()

	internal func call(from level: Level) {
		let move = MoveOperation(cabin: self.cabin, destination: level)
		for doors in doorControllers.map({ $0.doors }) {
			let close = CloseDoorsOperation(doors: doors)
			operationQueue.addOperation(close)
			move.addDependency(close)
		}
		operationQueue.addOperation(move)
		let openDoors = OpenDoorsOperation(doors: doorControllers[level].doors)
		openDoors.addDependency(move)
		operationQueue.addOperation(openDoors)
	}

	private func loadDoorControllers() {
		for level in 0..<dataSource.numberOfLevelsForElevatorController(self) {
			let doors = dataSource.elevatorController(self, doorsForLevel: level)
			let panel = dataSource.elevatorController(self, panelForLevel: level)
			let doorController = DoorController(doors: doors, panel: panel, delegate: self, dataSource: self)
			doorControllers.append(doorController)
		}
	}
}

extension ElevatorController: DoorControllerDelegate {
	func doorControllerDidCall(doorController: DoorController) {
		guard let level = doorControllers.indexOf({$0 === doorController}) else { return }
		call(from: level)
	}
}

extension ElevatorController: CabinDelegate {
	func cabinDidChangeState(cabin: Cabin) {
		print(cabin.state)
		for controller in doorControllers {
			controller.reloadData()
		}
	}
}

extension ElevatorController: DoorControllerDataSource {
	func displayedTextForDoorController(doorController: DoorController) -> String {
		return dataSource.elevatorController(self, abbreviationForLevel: cabin.currentLevel)
	}
}
