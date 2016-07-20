internal protocol ExternalPanelDelegate {
	func externalPanelDidCall(externalPanel: ExternalPanel)
}

internal protocol ExternalPanelDataSource {
	func displayedTextForExternalPanel(externalPanel: ExternalPanel) -> String
}

/// An instance of `ExternalPanel` represents the physical panel that is visible
/// from a building’s floor.
public final class ExternalPanel {

	/**
	Calls the cabin.
	*/
	public func call() {
		delegate?.externalPanelDidCall(self)
	}

	/// A function that runs every time the text displayed in the panel changes.
	public var displayedTextDidChange: () -> () = {}

	/// The text that is currently being displayed by the panel.
	public var displayedText = "" {
		didSet {
			displayedTextDidChange()
		}
	}

	/**
	Creates an instance of an external panel.

	- returns: The newly created instance.
	*/
	public init() {}

	internal var delegate: ExternalPanelDelegate?

	internal var dataSource: ExternalPanelDataSource? {
		didSet {
			reloadData()
		}
	}

	internal func reloadData() {
		guard let dataSource = dataSource else { return }
		displayedText = dataSource.displayedTextForExternalPanel(self)
	}
}
