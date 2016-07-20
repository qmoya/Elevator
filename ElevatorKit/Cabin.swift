internal protocol CabinDelegate {
	func cabinDidChangeState(cabin: Cabin)
}

/// An instance of `Cabin` represents the movable component in an elevator setup.
public final class Cabin {

	/**
	Creates an instance of a cabin.

	- returns: The new instance.
	*/
	public init() {}

	/// A function that will be called whenever the cabin starts or stops moving.
	public var didChangeState: () -> () = {}

	/// An integer representing the level at which the cabin is located.
	public var indexOfCurrentStory: Int {
		return currentLevel
	}

	internal var currentLevel: Int {
		return state.level
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

	/// The `Doors` instance that is currently visible from inside the cabin.
	internal(set) public var doors: Doors?

	internal var previousStates = [State]()

	internal var delegate: CabinDelegate?

	internal var state: State = .Stopped(0) {
		didSet {
			previousStates.append(oldValue)
			if state != oldValue {
				delegate?.cabinDidChangeState(self)
			}
		}
	}
}

extension Cabin.State: Equatable {}

// MARK: Equatable

internal func == (lhs: Cabin.State, rhs: Cabin.State) -> Bool {
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
