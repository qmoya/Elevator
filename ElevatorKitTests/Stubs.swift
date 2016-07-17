@testable import ElevatorKit

class StubElevatorControllerDataSource: ElevatorControllerDataSource {
	func elevatorController(elevatorController: ElevatorController, doorsForLevel level: Level) -> Doors {
		return Doors(state: .Closed)
	}

	func elevatorController(elevatorController: ElevatorController, abbreviationForLevel level: Level) -> String {
		return ""
	}

	func elevatorController(elevatorController: ElevatorController, panelForLevel level: Level) -> ExternalPanel {
		return ExternalPanel()
	}

	func numberOfLevelsForElevatorController(elevatorController: ElevatorController) -> Int {
		return 3
	}

	func cabinPanelForElevatorController(elevatorController: ElevatorController) -> CabinPanel {
		return CabinPanel()
	}

	func cabinForElevatorController(elevatorController: ElevatorController) -> Cabin {
		return Cabin(level: 0)
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

	func isJanitorModeEnabledForCabinPanel(cabinPanel: CabinPanel) -> Bool {
		return isJanitorModeEnabled
	}

	func isJanitorModeAvailableForCabinPanel(cabinPanel: CabinPanel) -> Bool {
		return isJanitorModeAvailable
	}
}
