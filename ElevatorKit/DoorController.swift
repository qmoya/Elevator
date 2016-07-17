protocol DoorControllerDelegate {
	func doorControllerDidCall(doorController: DoorController)
}

protocol DoorControllerDataSource {
	func displayedTextForDoorController(doorController: DoorController) -> String 
}

class DoorController {
	let doors: Doors

	var displayedText = ""

	let delegate: DoorControllerDelegate

	let dataSource: DoorControllerDataSource

	let externalPanel: ExternalPanel

	init(doors: Doors, panel: ExternalPanel, delegate: DoorControllerDelegate, dataSource: DoorControllerDataSource) {
		self.doors = doors
		self.delegate = delegate
		self.dataSource = dataSource
		self.externalPanel = panel
		self.externalPanel.delegate = self
	}

	func reloadData() {
		displayedText = dataSource.displayedTextForDoorController(self)
	}
}

extension DoorController: ExternalPanelDelegate {
	func externalPanelDidCall(externalPanel: ExternalPanel) {
		delegate.doorControllerDidCall(self)
	}
}