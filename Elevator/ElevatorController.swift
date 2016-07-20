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

		var toggled: Mode {
			switch self {
			case .Normal:
				return .Janitor
			case .Janitor:
				return .Normal
			}
		}
	}

	var mode: Mode = .Normal {
		didSet {
			cabinPanel.isJanitorModeEnabled = mode == .Janitor
		}
	}

	private var isJanitorModeAvailable: Bool = true {
		didSet {
			cabinPanel.isJanitorModeAvailable = isJanitorModeAvailable
		}
	}

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
			synchronousCall(destination)
			return
		}
		asynchronousCall(destination)
	}
	
	private var timeIntervalForDoorsOperation: NSTimeInterval = 1
	
	private var timeIntervalForMoveOperation: NSTimeInterval = 2

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

	private func panelText() -> String {
		let arrow = cabin.state.arrow
		let abbreviation = dataSource.elevatorController(self, abbreviationForLevel: cabin.currentLevel)
		return "\(arrow) \(abbreviation)"
	}
	
	private func synchronousCall(destination: Level) {
		for doors in allDoors {
			doors.state = .Closed
		}
		cabin.state = .Stopped(destination)
		floorControllers[destination].doors.state = .Open
	}
	
	private func asynchronousCall(destination: Level) {
		isJanitorModeAvailable = false
		let move = MoveOperation(cabin: self.cabin, destination: destination, timeInterval: timeIntervalForMoveOperation)
		for close in allCloseDoorsOperations {
			move.addDependency(close)
			operationQueue.addOperation(close)
		}
		let open = OpenDoorsOperation(doors: floorControllers[destination].doors, timeInterval: timeIntervalForDoorsOperation)
		open.addDependency(move)
		open.completionBlock = { [weak self] in
			self?.isJanitorModeAvailable = true
		}
		operationQueue.addOperations([move, open], waitUntilFinished: false)
	}
	
	private var allDoors: [Doors] {
		return floorControllers.map({$0.doors})
	}
	
	private var allCloseDoorsOperations: [CloseDoorsOperation] {
		return floorControllers.map({$0.closeDoorsOperation(timeIntervalForDoorsOperation)})
	}
}

extension ElevatorController: FloorControllerDelegate {
	func floorControllerDidCall(floorController: FloorController) {
		if mode == .Janitor {
			return
		}
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
		return panelText()
	}
}

extension ElevatorController: CabinPanelDataSource {
	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int {
		return dataSource.numberOfLevelsForElevatorController(self)
	}

	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String {
		return panelText()
	}
}

extension ElevatorController: CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel level: Level) {
		call(level)
	}

	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel) {
		mode = mode.toggled
		NSOperationQueue.mainQueue().addOperationWithBlock {
			cabinPanel.janitorModeDidChange()
		}
	}

	func cabinPanelDidChangeAvailabilityOfJanitorMode(cabinPanel: CabinPanel) {
		NSOperationQueue.mainQueue().addOperationWithBlock {
			cabinPanel.janitorModeAvailabilityDidChange()
		}
	}
}

extension ElevatorController: DoorsDelegate {
	func doorsDidChangeState(doors: Doors) {
		NSOperationQueue.mainQueue().addOperationWithBlock {
			doors.didChangeExteriorState()
			doors.didChangeInteriorState()
		}
	}
}
