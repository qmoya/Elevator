@testable import ElevatorKit

class TestCabinDelegate: CabinDelegate {
	var cabinDidChangeStateWasCalled = false

	func cabinDidChangeState(cabin: Cabin) {
		cabinDidChangeStateWasCalled = true
	}
}

class MockFloorControllerDelegate: FloorControllerDelegate {
	var didCall = false

	func floorControllerDidCall(floorController: FloorController) {
		didCall = true
	}
}

class MockExternalPanelDelegate: ExternalPanelDelegate {
	var externalPanelDidCallWasCalled = false
	func externalPanelDidCall(externalPanel: ExternalPanel) {
		externalPanelDidCallWasCalled = true
	}
}

class MockCabinPanelDelegate: CabinPanelDelegate {
	var isJanitorModeSelected = false
	var shouldToggleJanitorMode = false
	
	enum State {
		case NotCalled
		case Called(Level)

		var level: Level? {
			switch self {
			case .NotCalled:
				return nil
			case .Called(let level):
				return level
			}
		}
	}

	var state: State = .NotCalled

	func cabinPanel(cabinPanel: CabinPanel, didCallLevel level: Level) {
		state = .Called(level)
	}

	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel) {
		isJanitorModeSelected = !isJanitorModeSelected
	}

	func cabinPanelShouldToggleJanitorMode(cabinPanel: CabinPanel) -> Bool {
		return shouldToggleJanitorMode
	}
}
