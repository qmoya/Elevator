import UIKit
import ElevatorKit

final class App {
	let storyboard = UIStoryboard(name: "Main", bundle: nil)

	let navigationController: UINavigationController

	var elevatorController: ElevatorController!

	var storiesViewController: StoriesViewController!

	let building = Building(stories: [
		Story(name: "Basement", abbreviation: "B", backgroundImageName: "Black"),
		Story(name: "Ground Floor", abbreviation: "G", backgroundImageName: "Blue"),
		Story(name: "First Floor", abbreviation: "1", backgroundImageName: "Green"),
		Story(name: "Second Floor", abbreviation: "2", backgroundImageName: "Pink"),
		Story(name: "Third Floor", abbreviation: "3", backgroundImageName: "Yellow"),
		Story(name: "Fourth Floor", abbreviation: "4", backgroundImageName: "Purple"),
		Story(name: "Fifth Floor", abbreviation: "5", backgroundImageName: "Red"),
		Story(name: "Sixth Floor", abbreviation: "6", backgroundImageName: "Cyan"),
		], indexOfDefaultStory: 1)


	init(window: UIWindow) {
		guard let navigationController = window.rootViewController as? UINavigationController,
			buildingViewController = navigationController.viewControllers[0] as? StoriesViewController else {
			fatalError("unexpected initial view controllers")
		}

		self.navigationController = navigationController
		self.storiesViewController = buildingViewController
		elevatorController = ElevatorController(dataSource: self)

		configureStoriesViewController()
	}

	private func configureStoriesViewController() {
		storiesViewController.storyViewController = storyViewControllerForStory(building.defaultStory)!
		storiesViewController.storyViewControllerBelowStoryViewController = storyViewControllerBelowStoryViewController
		storiesViewController.storyViewControllerAboveStoryViewController = storyViewControllerAboveStoryViewController
	}

	private func initialStoryViewController() -> StoryViewController {
		return storyViewControllerForStory(building.stories[1])!
	}

	private func storyViewControllerBelowStoryViewController(storyViewController: StoryViewController) -> StoryViewController? {
		guard let story = storyViewController.story, storyBelow = building.storyBelowStory(story) else { return nil }
		return storyViewControllerForStory(storyBelow)
	}

	private func storyViewControllerAboveStoryViewController(storyViewController: StoryViewController) -> StoryViewController? {
		guard let story = storyViewController.story, storyAbove = building.storyAboveStory(story) else { return nil }
		return storyViewControllerForStory(storyAbove)
	}

	private func storyViewControllerForStory(story: Story) -> StoryViewController? {
		guard let viewController = storyboard.instantiateViewControllerWithIdentifier("StoryViewControllerStoryboardIdentifier") as? StoryViewController else { fatalError() }
		viewController.story = story
		viewController.didTapEnter = showElevator
		return viewController
	}

	private func instantiateCabinNavigationController() -> UINavigationController {
		guard let navigationController = storyboard.instantiateViewControllerWithIdentifier("ElevatorNavigationControllerStoryboardIdentifier") as? UINavigationController,
			elevatorViewController = navigationController.topViewController as? CabinViewController
			else { fatalError("couldn't find expected view controllers") }
		elevatorViewController.didTapExit = exitElevator
		elevatorViewController.cabin = building.cabin
		elevatorViewController.panel = building.cabinPanel
		return navigationController
	}

	private func showElevator() {
		let navigationController = instantiateCabinNavigationController()
		navigationController.modalPresentationStyle = .FormSheet
		self.navigationController.presentViewController(navigationController, animated: true, completion: nil)
	}

	private func exitElevator() {
		let level = building.cabin.indexOfCurrentStory
		let story = building.stories[level]
		if let viewController = storyViewControllerForStory(story) {
			storiesViewController.storyViewController = viewController
		}
		navigationController.dismissViewControllerAnimated(true, completion: nil)
	}
}

extension App: ElevatorControllerDataSource {
	func elevatorController(elevatorController: ElevatorController, doorsForLevelAtIndex index: Int) -> Doors {
		return building.doorsForStoryAtIndex(index)
	}

	func elevatorController(elevatorController: ElevatorController, abbreviationForLevelAtIndex index: Int) -> String {
		return building.abbreviationForStoryAtIndex(index)
	}

	func elevatorController(elevatorController: ElevatorController, panelForLevelAtIndex index: Int) -> ExternalPanel {
		return building.panelForStoryAtIndex(index)
	}

	func numberOfLevelsForElevatorController(elevatorController: ElevatorController) -> Int {
		return building.stories.count
	}

	func cabinForElevatorController(elevatorController: ElevatorController) -> Cabin {
		return building.cabin
	}

	func cabinPanelForElevatorController(elevatorController: ElevatorController) -> CabinPanel {
		return building.cabinPanel
	}

	func defaultCabinLevelForElevatorController(elevatorController: ElevatorController) -> Int {
		return building.defaultLevel
	}
}

class SplitViewControllerDelegate: NSObject, UISplitViewControllerDelegate {
	func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
		return false
	}
}
