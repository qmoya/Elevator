internal protocol FloorControllerDelegate {
	func floorControllerDidCall(floorController: FloorController)
}

internal protocol FloorControllerDataSource {
	func displayedTextForFloorController(floorController: FloorController) -> String
}

internal final class FloorController {
	internal let doors: Doors

	internal let delegate: FloorControllerDelegate

	internal let dataSource: FloorControllerDataSource

	internal let externalPanel: ExternalPanel

	init(doors: Doors, panel: ExternalPanel, delegate: FloorControllerDelegate, dataSource: FloorControllerDataSource) {
		self.doors = doors
		self.delegate = delegate
		self.dataSource = dataSource
		self.externalPanel = panel
		self.externalPanel.delegate = self
		self.externalPanel.dataSource = self
	}

	internal func reloadData() {
		externalPanel.reloadData()
	}

	internal func closeDoorsOperation(timeInterval: NSTimeInterval) -> CloseDoorsOperation {
		return CloseDoorsOperation(doors: doors, timeInterval: timeInterval)
	}
}

extension FloorController: ExternalPanelDelegate {
	func externalPanelDidCall(externalPanel: ExternalPanel) {
		delegate.floorControllerDidCall(self)
	}
}

extension FloorController: ExternalPanelDataSource {
	func displayedTextForExternalPanel(externalPanel: ExternalPanel) -> String {
		return self.dataSource.displayedTextForFloorController(self)
	}
}
