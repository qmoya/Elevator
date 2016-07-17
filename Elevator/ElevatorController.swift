public typealias Level = Int

public protocol ElevatorControllerDataSource {
	func numberOfLevelsForElevatorController(elevatorController: ElevatorController) -> Int
	func cabinForElevatorController(elevatorController: ElevatorController) -> Cabin
	func cabinPanelForElevatorController(elevatorController: ElevatorController) -> CabinPanel
	func elevatorController(elevatorController: ElevatorController, abbreviationForLevel level: Level) -> String
	func elevatorController(elevatorController: ElevatorController, doorsForLevel level: Level) -> Doors
	func elevatorController(elevatorController: ElevatorController, panelForLevel level: Level) -> ExternalPanel
}

public final class ElevatorController {
	private(set) var cabin: Cabin!

	private(set) var cabinPanel: CabinPanel!

	public enum Mode {
		case Normal
		case Janitor
	}

	private(set) var mode: Mode = .Normal

	public func setMode(mode: Mode) throws {
		if mode == .Janitor && !shouldEnableJanitorMode {
			return
		}
		self.mode = mode
	}

	private var shouldEnableJanitorMode: Bool {
		return operationQueue.operationCount == 0
	}

	public let dataSource: ElevatorControllerDataSource

	public init(dataSource: ElevatorControllerDataSource) {
		self.dataSource = dataSource
		loadData()
	}

	internal var floorControllers = [FloorController]()

	internal let operationQueue = NSOperationQueue()

	internal func call(destination: Level) {
		let move = MoveOperation(cabin: self.cabin, destination: destination)
		for doors in floorControllers.map({ $0.doors }) {
			let close = CloseDoorsOperation(doors: doors)
			operationQueue.addOperation(close)
			move.addDependency(close)
		}
		operationQueue.addOperation(move)
		let openDoors = OpenDoorsOperation(doors: floorControllers[destination].doors)
		openDoors.addDependency(move)
		operationQueue.addOperation(openDoors)
	}

	private func loadData() {
		for level in 0..<dataSource.numberOfLevelsForElevatorController(self) {
			let doors = dataSource.elevatorController(self, doorsForLevel: level)
			let panel = dataSource.elevatorController(self, panelForLevel: level)
			let floorController = FloorController(doors: doors, panel: panel, delegate: self, dataSource: self)
			floorControllers.append(floorController)
		}

		cabin = dataSource.cabinForElevatorController(self)
		cabin.delegate = self

		cabinPanel = dataSource.cabinPanelForElevatorController(self)
		cabinPanel.dataSource = self
		cabinPanel.delegate = self
	}
}

extension ElevatorController: FloorControllerDelegate {
	func floorControllerDidCall(floorController: FloorController) {
		guard let level = floorControllers.indexOf({$0 === floorController}) else { return }
		call(level)
	}
}

extension ElevatorController: CabinDelegate {
	func cabinDidChangeState(cabin: Cabin) {
		print(cabin.state)
		for controller in floorControllers {
			controller.reloadData()
		}
	}
}

extension ElevatorController: FloorControllerDataSource {
	func displayedTextForFloorController(floorController: FloorController) -> String {
		return dataSource.elevatorController(self, abbreviationForLevel: cabin.currentLevel)
	}
}

extension ElevatorController: CabinPanelDataSource {
	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int {
		return dataSource.numberOfLevelsForElevatorController(self)
	}

	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String {
		return dataSource.elevatorController(self, abbreviationForLevel: cabin.currentLevel)
	}

	func isJanitorModeEnabledForCabinPanel(cabinPanel: CabinPanel) -> Bool {
		return mode == .Janitor
	}

	func isJanitorModeAvailableForCabinPanel(cabinPanel: CabinPanel) -> Bool {
		return shouldEnableJanitorMode
	}
}

extension ElevatorController: CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel level: Level) {
		call(level)
	}

	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel) {
		if mode == .Normal {
			mode = .Janitor
			return
		}
		mode = .Normal
	}
	
	func cabinPanelShouldToggleJanitorMode(cabinPanel: CabinPanel) -> Bool {
		return shouldEnableJanitorMode
	}
}
