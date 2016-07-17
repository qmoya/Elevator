protocol CabinDelegate {
	func cabinDidChangeState(cabin: Cabin)
}

public final class Cabin {

	internal enum State {
		case Stopped(Level)
		case Moving(Level)
	}

	internal var history = [State]()

	internal var delegate: CabinDelegate?

	internal var state: State = .Stopped(0) {
		didSet {
			history.append(state)
			delegate?.cabinDidChangeState(self)
		}
	}

	// TODO: does the current floor actually belong to the elevator?
	// to unwrap the current level without having to switch all the time
	internal var currentLevel: Level {
		var story: Level
		switch state {
		case .Stopped(let s):
			story = s
		case .Moving(let s):
			story = s
		}
		return story
	}

	public init() {}
}

extension Cabin.State: Equatable {}

// MARK: Equatable

func ==(lhs: Cabin.State, rhs: Cabin.State) -> Bool {
	switch (lhs, rhs) {
	case (.Stopped(let leftStory), .Stopped(let rightStory)):
		return leftStory == rightStory
	case (.Moving(let leftStory), .Moving(let rightStory)):
		return leftStory == rightStory
	default:
		return false
	}
}
