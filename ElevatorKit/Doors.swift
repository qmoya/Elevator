internal protocol DoorsDelegate {
	func doorsDidChangeState(doors: Doors)
}

/// An instance of `Doors` represents the doors that are part of an elevator setup.
/// Generally, a building will have as many doors as levels.
public final class Doors {
	internal enum State {
		case Opening
		case Open
		case Closing
		case Closed
	}

	internal init(state: State) {
		self.state = state
	}

	convenience public init() {
		self.init(state: .Closed)
	}

	public var areOpen: Bool {
		return state == .Open
	}

	public var didChangeExteriorState: () -> () = {}

	public var didChangeInteriorState: () -> () = {}

	internal var delegate: DoorsDelegate?

	internal var previousStates = [State]()

	internal(set) internal var state: State {
		didSet {
			previousStates.append(oldValue)
			if state != oldValue {
				self.delegate?.doorsDidChangeState(self)
			}
		}
	}
}
