internal protocol CabinDelegate {
	func cabinDidChangeState(cabin: Cabin)
}

public final class Cabin {

	public init(level: Level) {
		self.state = .Stopped(level)
	}

	internal enum State {
		case Stopped(Level)
		case Moving(Level)

		var level: Level {
			switch self {
			case .Stopped(let s):
				return s
			case .Moving(let s):
				return s
			}
		}
	}

	internal var previousStates = [State]()

	internal var delegate: CabinDelegate?

	internal var state: State {
		didSet {
			previousStates.append(oldValue)
			if state != oldValue {
				delegate?.cabinDidChangeState(self)
			}
		}
	}

	internal var currentLevel: Level {
		return state.level
	}
}

extension Cabin.State: Equatable {}

// MARK: Equatable

func ==(lhs: Cabin.State, rhs: Cabin.State) -> Bool {
	switch (lhs, rhs) {
	case (.Stopped(let leftLevel), .Stopped(let rightLevel)):
		return leftLevel == rightLevel
	case (.Moving(let leftLevel), .Moving(let rightLevel)):
		return leftLevel == rightLevel
	default:
		return false
	}
}
