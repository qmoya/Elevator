protocol DoorsDelegate {
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

	internal var delegate: DoorsDelegate?

	internal var previousStates = [State]()

	internal var state: State {
		didSet {
			previousStates.append(oldValue)
			if state != oldValue {
				delegate?.doorsDidChangeState(self)
			}
		}
	}
}
