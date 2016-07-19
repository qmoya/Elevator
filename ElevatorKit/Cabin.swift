internal protocol CabinDelegate {
	func cabinDidChangeState(cabin: Cabin)
}

public final class Cabin {

	public init(level: Level) {
		self.state = .Stopped(level)
	}

	internal enum State {
		case Stopped(Level)
		case MovingUp(Level)
		case MovingDown(Level)

		var level: Level {
			switch self {
			case .Stopped(let l):
				return l
			case .MovingUp(let l):
				return l
			case .MovingDown(let l):
				return l
			}
		}

		var arrow: String {
			switch self {
			case .MovingUp:
				return "↑"
			case .MovingDown:
				return "↓"
			case .Stopped:
				return ""
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

	public var currentLevel: Level {
		return state.level
	}
}

extension Cabin.State: Equatable {}

// MARK: Equatable

func ==(lhs: Cabin.State, rhs: Cabin.State) -> Bool {
	switch (lhs, rhs) {
	case (.Stopped(let leftLevel), .Stopped(let rightLevel)):
		return leftLevel == rightLevel
	case (.MovingUp(let leftLevel), .MovingUp(let rightLevel)):
		return leftLevel == rightLevel
	case (.MovingDown(let leftLevel), .MovingDown(let rightLevel)):
		return leftLevel == rightLevel
	default:
		return false
	}
}
