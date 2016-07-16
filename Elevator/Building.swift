import Foundation

public struct Building {
	public let stories: [Story]

	public func storyAboveStory(story: Story) -> Story? {
		guard let index = stories.indexOf(story) else { return nil }
		if index == stories.count-1 { return nil }
		return stories[index+1]
	}

	public func storyBelowStory(story: Story) -> Story? {
		guard let index = stories.indexOf(story) else { return nil }
		if index == 0 { return nil }
		return stories[index-1]
	}

	public func storiesBetween(origin: Story, destination: Story) -> [Story] {
		guard let originIndex = stories.indexOf(origin), destIndex = stories.indexOf(destination) else { return [] }
		var array: Array<Story>
		if originIndex < destIndex {
			array = Array(stories[originIndex...destIndex])
		} else {
			array = Array(stories[destIndex...originIndex])
		}
		array.removeFirst()
		if !array.isEmpty {
			array.removeLast()
		}
		return array
	}

	public init(stories: [Story]) {
		self.stories = stories
	}
}
