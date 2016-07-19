public typealias Level = Int

public protocol ElevatorControllerDataSource {
	func numberOfLevelsForElevatorController(elevatorController: ElevatorController) -> Int
	func cabinForElevatorController(elevatorController: ElevatorController) -> Cabin
	func cabinPanelForElevatorController(elevatorController: ElevatorController) -> CabinPanel
	func elevatorController(elevatorController: ElevatorController, abbreviationForLevel level: Level) -> String
	func elevatorController(elevatorController: ElevatorController, doorsForLevel level: Level) -> Doors
	func elevatorController(elevatorController: ElevatorController, panelForLevel level: Level) -> ExternalPanel
	func defaultCabinLevelForElevatorController(elevatorController: ElevatorController) -> Level
}

public final class ElevatorController {
	private(set) public var cabin: Cabin!

	private(set) public var cabinPanel: CabinPanel!

	public enum Mode {
		case Normal
		case Janitor
	}

	private(set) var mode: Mode = .Normal {
		didSet {
			print("mode was set to \(mode)")
		}
	}

	public func setMode(mode: Mode) throws {
		if mode == .Janitor && !shouldEnableJanitorMode {
			return
		}
		self.mode = mode
	}

	private var shouldEnableJanitorMode: Bool = true

	public let dataSource: ElevatorControllerDataSource

	public init(dataSource: ElevatorControllerDataSource) {
		self.dataSource = dataSource
		operationQueue.maxConcurrentOperationCount = 1
		loadData()
	}

	internal var floorControllers = [FloorController]()

	internal let operationQueue = NSOperationQueue()

	internal func call(destination: Level) {
		if mode == .Janitor {
			cabin.state = .Stopped(destination)
			return
		}
		shouldEnableJanitorMode = false
		let move = MoveOperation(cabin: self.cabin, destination: destination, timeInterval: 2)
		for close in floorControllers.map({$0.closeDoorsOperation()}) {
			move.addDependency(close)
			operationQueue.addOperation(close)
		}
		let open = OpenDoorsOperation(doors: floorControllers[destination].doors, timeInterval: 1)
		open.addDependency(move)
		operationQueue.addOperations([move, open], waitUntilFinished: false)
	}

	private func loadFloorControllers() {
		for level in 0..<dataSource.numberOfLevelsForElevatorController(self) {
			let doors = dataSource.elevatorController(self, doorsForLevel: level)
			doors.delegate = self
			if level == dataSource.defaultCabinLevelForElevatorController(self) {
				doors.state = .Open
			}
			let panel = dataSource.elevatorController(self, panelForLevel: level)
			let floorController = FloorController(doors: doors, panel: panel, delegate: self, dataSource: self)
			floorControllers.append(floorController)
		}
	}

	private func loadCabin() {
		cabin = dataSource.cabinForElevatorController(self)
		let defaultLevel = dataSource.defaultCabinLevelForElevatorController(self)
		cabin.state = .Stopped(defaultLevel)
		cabin.doors = dataSource.elevatorController(self, doorsForLevel: defaultLevel)
		cabin.delegate = self
	}

	private func loadCabinPanel() {
		cabinPanel = dataSource.cabinPanelForElevatorController(self)
		cabinPanel.dataSource = self
		cabinPanel.delegate = self
	}

	public func loadData() {
		loadCabin()
		loadFloorControllers()
		loadCabinPanel()
	}

	private func reloadFloorControllersData() {
		for controller in floorControllers {
			NSOperationQueue.mainQueue().addOperationWithBlock {
				controller.reloadData()
			}
		}
	}

	private func reloadCabinData() {
		cabin.doors = dataSource.elevatorController(self, doorsForLevel: cabin.currentLevel)
		NSOperationQueue.mainQueue().addOperationWithBlock { [weak self] in
			guard let s = self else { return }
			s.cabin.didChangeState()
			s.cabinPanel.reloadData()
		}
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
		reloadFloorControllersData()
		reloadCabinData()
	}
}

extension ElevatorController: FloorControllerDataSource {
	func displayedTextForFloorController(floorController: FloorController) -> String {
		let arrow = cabin.state.arrow
		let abbreviation = dataSource.elevatorController(self, abbreviationForLevel: cabin.currentLevel)
		return "\(arrow) \(abbreviation)"
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
		return mode == .Janitor || shouldEnableJanitorMode
	}
}

extension ElevatorController: CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel level: Level) {
		call(level)
	}

	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel) {
		defer {
			cabinPanel.reloadData()
		}
		if mode == .Normal {
			mode = .Janitor
			return
		}
		mode = .Normal
	}
}

extension ElevatorController: DoorsDelegate {
	func doorsDidChangeState(doors: Doors) {
		NSOperationQueue.mainQueue().addOperationWithBlock {
			print("doors: \(doors.state)")
			doors.didChangeExteriorState()
			doors.didChangeInteriorState()
		}
	}
}
