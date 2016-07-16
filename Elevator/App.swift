import UIKit
import ElevatorKit

final class App {

	let storyboard = UIStoryboard(name: "Main", bundle: nil)

	let navigationController: UINavigationController

	let building = Building(stories: [
		Story(name: "First", abbreviation: "1"),
		Story(name: "Second", abbreviation: "2"),
		Story(name: "Third", abbreviation: "3")
	])

	let elevatorController: ElevatorController

	init(window: UIWindow) {
		guard let navigationController = window.rootViewController as? UINavigationController, buildingViewController = navigationController.viewControllers[0] as? BuildingViewController else {
			fatalError("unexpected initial view controllers")
		}

		self.navigationController = navigationController

		elevatorController = ElevatorController(elevator: Elevator(story: building.stories[1]), building: building)

		buildingViewController.initialStoryViewController = initialStoryViewController
		buildingViewController.storyViewControllerBelowStoryViewController = storyViewControllerBelowStoryViewController
		buildingViewController.storyViewControllerAboveStoryViewController = storyViewControllerAboveStoryViewController
		buildingViewController.didChangeStoryViewController = updateNavigationBarForStoryViewController
	}

	func initialStoryViewController() -> StoryViewController {
		return storyViewControllerForStory(building.stories[1])!
	}

	func storyViewControllerBelowStoryViewController(storyViewController: StoryViewController) -> StoryViewController? {
		guard let story = storyViewController.story, storyBelow = building.storyBelowStory(story) else { return nil }
		return storyViewControllerForStory(storyBelow)
	}

	func storyViewControllerAboveStoryViewController(storyViewController: StoryViewController) -> StoryViewController? {
		guard let story = storyViewController.story, storyAbove = building.storyAboveStory(story) else { return nil }
		return storyViewControllerForStory(storyAbove)
	}

	func storyViewControllerForStory(story: Story) -> StoryViewController? {
		guard let viewController = storyboard.instantiateViewControllerWithIdentifier("StoryViewControllerStoryboardIdentifier") as? StoryViewController else { fatalError() }
		viewController.story = story
		viewController.elevatorController = elevatorController
		viewController.didTapEnter = showElevator
		return viewController
	}

	func updateNavigationBarForStoryViewController(storyViewController: StoryViewController) {
		navigationController.navigationBar.setItems([storyViewController.navigationItem], animated: false)
	}

	func showElevator() {
		guard let navigationController = storyboard.instantiateViewControllerWithIdentifier("ElevatorNavigationControllerStoryboardIdentifier") as? UINavigationController,
			elevatorViewController = navigationController.topViewController as? ElevatorViewController
			else { return }
		elevatorViewController.elevator = elevatorController.elevator
		elevatorViewController.didTapExit = exitElevator
		self.navigationController.presentViewController(navigationController, animated: true, completion: nil)
	}

	func exitElevator() {
		navigationController.dismissViewControllerAnimated(true, completion: nil)
	}
}
