import ElevatorKit

class Story {
	let name: String
	let abbreviation: String

	let doors = Doors()
	let panel = ExternalPanel()

	init(name: String, abbreviation: String) {
		self.name = name
		self.abbreviation = abbreviation
	}
}
