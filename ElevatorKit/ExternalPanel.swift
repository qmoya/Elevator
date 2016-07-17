internal protocol ExternalPanelDelegate {
	func externalPanelDidCall(externalPanel: ExternalPanel)
}

public final class ExternalPanel {
	internal var delegate: ExternalPanelDelegate?

	public func call() {
		delegate?.externalPanelDidCall(self)
	}

	public init() {}
}