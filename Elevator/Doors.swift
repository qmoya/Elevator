// into own object to avoid namespaces in state
public final class Doors {
	enum State {
		case Opening
		case Closing
		case Open
		case Closed
	}

	var state = State.Closed {
		didSet {
			print(state)
		}
	}

	var didSetState: () -> () = {}
}
