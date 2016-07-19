internal protocol ExternalPanelDelegate {
	func externalPanelDidCall(externalPanel: ExternalPanel)
}

internal protocol ExternalPanelDataSource {
	func displayedTextForExternalPanel(externalPanel: ExternalPanel) -> String
}

public final class ExternalPanel {

	public func call() {
		delegate?.externalPanelDidCall(self)
	}

	public var displayedTextDidChange: () -> () = {}

	public var displayedText = "" {
		didSet {
			displayedTextDidChange()
		}
	}

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
