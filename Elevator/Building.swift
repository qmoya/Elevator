import ElevatorKit

struct Building {
	let stories: [Story]

	let defaultLevel: Int

	let cabin = Cabin()

	let cabinPanel = CabinPanel()

	var defaultStory: Story {
		return stories[defaultLevel]
	}

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

	func areDoorsOpenAtCurrentCabinLevel() -> Bool {
		return stories[cabin.indexOfCurrentStory].doors.areOpen
	}

	func doorsForStoryAtIndex(index: Int) -> Doors {
		return stories[index].doors
	}

	func abbreviationForStoryAtIndex(index: Int) -> String {
		return stories[index].abbreviation
	}

	func panelForStoryAtIndex(index: Int) -> ExternalPanel {
		return stories[index].panel
	}

	init(stories: [Story], indexOfDefaultStory: Int) {
		self.stories = stories
		self.defaultLevel = indexOfDefaultStory
	}
}
