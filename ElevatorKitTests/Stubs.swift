@testable import ElevatorKit

class StubElevatorControllerDataSource: ElevatorControllerDataSource {
	var doors = Doors(state: .Closed)
	var abbreviation = ""
	var externalPanel = ExternalPanel()
	var numberOfLevels = 3
	var cabinPanel = CabinPanel()
	var defaultLevel = 0
	var cabin = Cabin()

	func elevatorController(elevatorController: ElevatorController, doorsForLevelAtIndex level: Level) -> Doors {
		return Doors(state: .Closed)
	}

	func elevatorController(elevatorController: ElevatorController, abbreviationForLevelAtIndex level: Level) -> String {
		return ""
	}

	func elevatorController(elevatorController: ElevatorController, panelForLevelAtIndex level: Level) -> ExternalPanel {
		return ExternalPanel()
	}

	func numberOfLevelsForElevatorController(elevatorController: ElevatorController) -> Int {
		return 3
	}

	func cabinPanelForElevatorController(elevatorController: ElevatorController) -> CabinPanel {
		return CabinPanel()
	}

	func cabinForElevatorController(elevatorController: ElevatorController) -> Cabin {
		return Cabin()
	}

	func defaultCabinLevelForElevatorController(elevatorController: ElevatorController) -> Level {
		return defaultLevel
	}
}

class StubFloorControllerDataSource: FloorControllerDataSource {
	var displayedText = ""

	func displayedTextForFloorController(floorController: FloorController) -> String {
		return displayedText
	}
}

extension FloorController {
	class func fakeFloorController() -> FloorController {
		let doors = Doors(state: .Closed)
		let panel = ExternalPanel()
		let delegate = MockFloorControllerDelegate()
		let dataSource = StubFloorControllerDataSource()
		return FloorController(doors: doors, panel: panel, delegate: delegate, dataSource: dataSource)
	}
}

class StubExternalPanelDataSource: ExternalPanelDataSource {
	let displayedText: String

	init(displayedText: String) {
		self.displayedText = displayedText
	}

	func displayedTextForExternalPanel(externalPanel: ExternalPanel) -> String {
		return displayedText
	}
}

class StubCabinPanelDataSource: CabinPanelDataSource {
	var numberOfLevels = 0
	var displayedText = ""
	var isJanitorModeEnabled = false
	var isJanitorModeAvailable = false

	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int {
		return numberOfLevels
	}

	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String {
		return displayedText
	}
}
