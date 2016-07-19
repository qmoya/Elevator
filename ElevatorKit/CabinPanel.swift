internal protocol CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel: Level)
	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel)
}

internal protocol CabinPanelDataSource {
	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int
	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String
	func isJanitorModeEnabledForCabinPanel(cabinPanel: CabinPanel) -> Bool
	func isJanitorModeAvailableForCabinPanel(cabinPanel: CabinPanel) -> Bool
}

public final class CabinPanel {
	internal var delegate: CabinPanelDelegate?
	internal var dataSource: CabinPanelDataSource? {
		didSet {
			reloadData()
		}
	}

	public func call(level: Level) {
		delegate?.cabinPanel(self, didCallLevel: level)
	}

	public func toggleJanitorMode() {
		delegate?.cabinPanelDidToggleJanitorMode(self)
	}

	private(set) public var isJanitorModeEnabled = false {
		didSet {
			if isJanitorModeEnabled != oldValue {
				janitorModeDidChange()
			}
		}
	}

	private(set) public var isJanitorModeAvailable = false {
		didSet {
			if isJanitorModeEnabled != oldValue {
				janitorModeAvailabilityDidChange()
			}
		}
	}

	private(set) public var displayedText = "" {
		didSet {
			if displayedText != oldValue {
				displayedTextDidChange()
			}
		}
	}

	public var displayedTextDidChange: () -> () = {}

	public var janitorModeDidChange: () -> () = {}

	public var janitorModeAvailabilityDidChange: () -> () = {}

	private(set) public var numberOfLevels = 0

	public init() {}

	internal func reloadData() {
		guard let dataSource = dataSource else { return }
		numberOfLevels = dataSource.numberOfLevelsForCabinPanel(self)
		displayedText = dataSource.displayedTextForCabinPanel(self)
		isJanitorModeEnabled = dataSource.isJanitorModeEnabledForCabinPanel(self)
		isJanitorModeAvailable = dataSource.isJanitorModeAvailableForCabinPanel(self)
	}
}
