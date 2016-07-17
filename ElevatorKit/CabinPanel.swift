internal protocol CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel: Level)
}

internal protocol CabinPanelDataSource {
	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int
	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String
}

public final class CabinPanel {
	internal var delegate: CabinPanelDelegate?
	internal var dataSource: CabinPanelDataSource?

	var numberOfLevels = 0

	public func call(level: Level) {
		delegate?.cabinPanel(self, didCallLevel: level)
	}

	private(set) var displayedText = ""

	public init() {}

	func reloadData() {
		guard let dataSource = dataSource else { return }
		numberOfLevels = dataSource.numberOfLevelsForCabinPanel(self)
		displayedText = dataSource.displayedTextForCabinPanel(self)
	}
}
