internal protocol CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel: Level)
	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel)
	func cabinPanelDidChangeAvailabilityOfJanitorMode(cabinPanel: CabinPanel)
}

internal protocol CabinPanelDataSource {
	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int
	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String
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
		isJanitorModeEnabled = !isJanitorModeEnabled
	}

	internal(set) public var isJanitorModeEnabled = false {
		didSet {
			if isJanitorModeEnabled != oldValue {
				delegate?.cabinPanelDidToggleJanitorMode(self)
			}
		}
	}

	internal(set) public var isJanitorModeAvailable = true {
		didSet {
			if isJanitorModeAvailable != oldValue {
				delegate?.cabinPanelDidChangeAvailabilityOfJanitorMode(self)
			}
		}
	}

	internal(set) public var displayedText = "" {
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
	}
}
