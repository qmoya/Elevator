internal protocol CabinPanelDelegate {
	func cabinPanel(cabinPanel: CabinPanel, didCallLevel: Level)
	func cabinPanelDidToggleJanitorMode(cabinPanel: CabinPanel)
	func cabinPanelDidChangeAvailabilityOfJanitorMode(cabinPanel: CabinPanel)
}

internal protocol CabinPanelDataSource {
	func numberOfLevelsForCabinPanel(cabinPanel: CabinPanel) -> Int
	func displayedTextForCabinPanel(cabinPanel: CabinPanel) -> String
}

/// An instance of `CabinPanel` represents the physical panel that is users can
/// handle inside the cabin.
public final class CabinPanel {
	internal var delegate: CabinPanelDelegate?

	internal var dataSource: CabinPanelDataSource? {
		didSet {
			reloadData()
		}
	}

	/**
	Calls the cabin from a particular index.

	- parameter index: The index from which the cabin has been called.
	*/
	public func call(levelAtIndex index: Int) {
		delegate?.cabinPanel(self, didCallLevel: index)
	}

	/**
	Toggles the janitor mode.
	*/
	public func toggleJanitorMode() {
		isJanitorModeEnabled = !isJanitorModeEnabled
	}

	/// Indicates whether or not the janitor mode is enabled.
	internal(set) public var isJanitorModeEnabled = false {
		didSet {
			if isJanitorModeEnabled != oldValue {
				delegate?.cabinPanelDidToggleJanitorMode(self)
			}
		}
	}

	/// Indicates whether or not the janitor mode is available.
	internal(set) public var isJanitorModeAvailable = true {
		didSet {
			if isJanitorModeAvailable != oldValue {
				delegate?.cabinPanelDidChangeAvailabilityOfJanitorMode(self)
			}
		}
	}

	/// Indicates the text that is currently displayed by the panel.
	internal(set) public var displayedText = "" {
		didSet {
			if displayedText != oldValue {
				displayedTextDidChange()
			}
		}
	}

	/// A function that is called every time the displayed text changes.
	public var displayedTextDidChange: () -> () = {}

	/// A function that is called every time the janitor mode is toggled.
	public var janitorModeDidChange: () -> () = {}

	/// A function that is called every time the availability of the janitor mode changes.
	public var janitorModeAvailabilityDidChange: () -> () = {}

	/**
	Creates an instance of a cabin panel.

	- returns: The new instance.
	*/
	public init() {}

	internal func reloadData() {
		guard let dataSource = dataSource else { return }
		displayedText = dataSource.displayedTextForCabinPanel(self)
	}
}
