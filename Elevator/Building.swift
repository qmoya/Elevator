import ElevatorKit

struct Building {
	let stories: [Story]
	let cabin = Cabin(level: 2)

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
//
//	func storiesBetween(origin: Story, destination: Story) -> [Story] {
//		guard let originIndex = stories.indexOf(origin), destIndex = stories.indexOf(destination) else { return [] }
//		var array: Array<Story>
//		if originIndex < destIndex {
//			array = Array(stories[originIndex...destIndex])
//		} else {
//			array = Array(stories[destIndex...originIndex])
//		}
//		array.removeFirst()
//		if !array.isEmpty {
//			array.removeLast()
//		}
//		return array
//	}

	init(stories: [Story]) {
		self.stories = stories
	}
}
