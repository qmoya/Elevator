import Foundation

public final class Elevator {

	internal enum State {
		case Stopped(Story)
		case Moving(Story)
	}

	internal var history = [State]()

	internal var state: State {
		didSet {
			history.append(state)
		}
	}

	// TODO: does the current floor actually belong to the elevator?
	// to unwrap the current level without having to switch all the time
	var currentStory: Story {
		var story: Story
		switch state {
		case .Stopped(let s):
			story = s
		case .Moving(let s):
			story = s
		}
		return story
	}

	public init(story: Story) {
		state = .Stopped(story)
	}
}

extension Elevator.State: Equatable {}

// MARK: Equatable

func ==(lhs: Elevator.State, rhs: Elevator.State) -> Bool {
	switch (lhs, rhs) {
	case (.Stopped(let leftStory), .Stopped(let rightStory)):
		return leftStory == rightStory
	case (.Moving(let leftStory), .Moving(let rightStory)):
		return leftStory == rightStory
	default:
		return false
	}
}
