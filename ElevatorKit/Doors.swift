public protocol DoorsDelegate {
	func doorsDidChangeState(doors: Doors)
}

public final class Doors {
	public enum State {
		case Opening
		case Open
		case Closing
		case Closed
	}

	public init(state: State) {
		self.state = state
	}

	public var delegate: DoorsDelegate?

	internal var previousStates = [State]()

	internal(set) public var state: State {
		didSet {
			previousStates.append(oldValue)
			if state != oldValue {
				dispatch_async(dispatch_get_main_queue()) { [weak self] in
					guard let s = self else { return }
					s.delegate?.doorsDidChangeState(s)
				}
			}
		}
	}
}
