internal protocol DoorsDelegate {
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

	public var didChangeExteriorState: () -> () = {}
	
	public var didChangeInteriorState: () -> () = {}

	internal var delegate: DoorsDelegate?

	internal var previousStates = [State]()

	internal(set) public var state: State {
		didSet {
			previousStates.append(oldValue)
			if state != oldValue {
				self.delegate?.doorsDidChangeState(self)
			}
		}
	}
}
