import Foundation

public struct Story {
	public let name: String
	public let abbreviation: String

	public let doors = Doors()

	public init(name: String, abbreviation: String) {
		self.name = name
		self.abbreviation = abbreviation
	}
}

extension Story: Equatable {}

// MARK: Equatable

public func ==(lhs: Story, rhs: Story) -> Bool {
	return lhs.abbreviation == rhs.abbreviation
}
