import Foundation

typealias Level = Int

final class Elevator {

	enum State {
		case Stopped(Level)
		case Moving(Level)
	}

	let doors = Doors()

	var state = State.Stopped(0)

	// to unwrap the current level without having to switch all the time
	var currentLevel: Level {
		var level: Int
		switch state {
		case .Stopped(let l):
			level = l
		case .Moving(let l):
			level = l
		}
		return level
	}
}
