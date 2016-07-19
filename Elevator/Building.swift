import ElevatorKit

struct Building {
	let stories: [Story]
	
	let defaultLevel: Int

	let cabin = Cabin(level: 1)

	let cabinPanel = CabinPanel()
	
	func storyAboveStory(story: Story) -> Story? {
		guard let index = stories.indexOf({$0 === story}) else { return nil }
		if index == stories.count-1 { return nil }
		return stories[index+1]
	}

	func storyBelowStory(story: Story) -> Story? {
		guard let index = stories.indexOf({$0 === story}) else { return nil }
		if index == 0 { return nil }
		return stories[index-1]
	}

	init(stories: [Story], defaultLevel: Level) {
		self.stories = stories
		self.defaultLevel = defaultLevel
	}
}
