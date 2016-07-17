internal protocol CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel: Level)
	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel)
	func cabinPanelShouldToggleJanitorMode(cabinPanel: CabinPanel) -> Bool
}

internal protocol CabinPanelDataSource {
	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int
	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String
	func isJanitorModeEnabledForCabinPanel(cabinPanel: CabinPanel) -> Bool
	func isJanitorModeAvailableForCabinPanel(cabinPanel: CabinPanel) -> Bool
}

public final class CabinPanel {
	internal var delegate: CabinPanelDelegate?
	internal var dataSource: CabinPanelDataSource?

	public func call(level: Level) {
		delegate?.cabinPanel(self, didCallLevel: level)
	}

	public func toggleJanitorMode() {
		guard let delegate = delegate else { return }
		if delegate.cabinPanelShouldToggleJanitorMode(self) {
			delegate.cabinPanelDidToggleJanitorMode(self)
		}
	}

	private(set) public var isJanitorModeEnabled = false

	private(set) public var isJanitorModeAvailable = false

	private(set) public var displayedText = ""

	private(set) public var numberOfLevels = 0

	public init() {}

	func reloadData() {
		guard let dataSource = dataSource else { return }
		numberOfLevels = dataSource.numberOfLevelsForCabinPanel(self)
		displayedText = dataSource.displayedTextForCabinPanel(self)
		isJanitorModeEnabled = dataSource.isJanitorModeEnabledForCabinPanel(self)
		isJanitorModeAvailable = dataSource.isJanitorModeAvailableForCabinPanel(self)
	}
}
