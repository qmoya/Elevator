// into own object to avoid namespaces in state
final class Doors {
	enum State {
		case Opening
		case Closing
		case Open
		case Closed
	}

	var state = State.Closed
}
