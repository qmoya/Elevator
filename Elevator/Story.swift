import ElevatorKit

class Story {
	let name: String
	let abbreviation: String
	let backgroundImageName: String

	let doors = Doors(state: .Closed)
	let panel = ExternalPanel()

	init(name: String, abbreviation: String, backgroundImageName: String) {
		self.name = name
		self.abbreviation = abbreviation
		self.backgroundImageName = backgroundImageName
	}
}
