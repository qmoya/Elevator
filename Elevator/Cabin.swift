internal protocol CabinDelegate {
	func cabinDidChangeState(cabin: Cabin)
	func cabinShouldMoveToLevel(level: Level) -> Bool
}

public final class Cabin {

	internal enum State {
		case Stopped(Level)
		case Moving(Level)
	}

	internal var previousState = [State]()

	internal var delegate: CabinDelegate?

	internal var state: State {
		willSet {

		}
		didSet {
			previousState.append(oldValue)
			delegate?.cabinDidChangeState(self)
		}
	}

	internal var currentLevel: Level {
		return Cabin.levelForState(state)
	}

	private class func levelForState(state: State) -> Level {
		var level: Level
		switch state {
		case .Stopped(let s):
			level = s
		case .Moving(let s):
			level = s
		}
		return level
	}

	public init(level: Level) {
		self.state = .Stopped(level)
	}
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
