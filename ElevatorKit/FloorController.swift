protocol FloorControllerDelegate {
	func floorControllerDidCall(floorController: FloorController)
}

protocol FloorControllerDataSource {
	func displayedTextForFloorController(floorController: FloorController) -> String
}

internal final class FloorController {
	let doors: Doors

	let delegate: FloorControllerDelegate

	let dataSource: FloorControllerDataSource

	let externalPanel: ExternalPanel

	init(doors: Doors, panel: ExternalPanel, delegate: FloorControllerDelegate, dataSource: FloorControllerDataSource) {
		self.doors = doors
		self.delegate = delegate
		self.dataSource = dataSource
		self.externalPanel = panel
		self.externalPanel.delegate = self
	}

	func reloadData() {
		externalPanel.displayedText = dataSource.displayedTextForFloorController(self)
	}
}

extension FloorController: ExternalPanelDelegate {
	func externalPanelDidCall(externalPanel: ExternalPanel) {
		delegate.floorControllerDidCall(self)
	}
}

//extension FloorController: ExternalPanelDataSource {
//
//}
