import UIKit
import ElevatorKit

final class App {

	let storyboard = UIStoryboard(name: "Main", bundle: nil)

	let navigationController: UINavigationController

	let building = Building(stories: [
		Story(name: "Basement", abbreviation: "B", backgroundImageName: "Black"),
		Story(name: "Ground Floor", abbreviation: "G", backgroundImageName: "Blue"),
		Story(name: "First Floor", abbreviation: "1", backgroundImageName: "Green"),
		Story(name: "Second Floor", abbreviation: "2", backgroundImageName: "Pink"),
		Story(name: "Third Floor", abbreviation: "3", backgroundImageName: "Yellow"),
		Story(name: "Fourth Floor", abbreviation: "4", backgroundImageName: "Purple"),
		Story(name: "Fifth Floor", abbreviation: "5", backgroundImageName: "Red"),
		Story(name: "Sixth Floor", abbreviation: "6", backgroundImageName: "Cyan"),
	])

	var elevatorController: ElevatorController!

	init(window: UIWindow) {
		guard let navigationController = window.rootViewController as? UINavigationController, buildingViewController = navigationController.viewControllers[0] as? BuildingViewController else {
			fatalError("unexpected initial view controllers")
		}

		self.navigationController = navigationController

		elevatorController = ElevatorController(dataSource: self)

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
		elevatorViewController.didTapExit = exitElevator
		elevatorViewController.cabin = building.cabin
		elevatorViewController.panel = building.cabinPanel
		
		self.navigationController.presentViewController(navigationController, animated: true, completion: nil)
	}

	func exitElevator() {
		navigationController.dismissViewControllerAnimated(true, completion: nil)
	}
}

extension App: ElevatorControllerDataSource {
	func elevatorController(elevatorController: ElevatorController, doorsForLevel level: Level) -> Doors {
		return building.stories[level].doors  // FIXME: Demeter
	}

	func elevatorController(elevatorController: ElevatorController, abbreviationForLevel level: Level) -> String {
		return building.stories[level].abbreviation // FIXME: Demeter
	}

	func elevatorController(elevatorController: ElevatorController, panelForLevel level: Level) -> ExternalPanel {
		return building.stories[level].panel // FIXME: Demeter
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
}
