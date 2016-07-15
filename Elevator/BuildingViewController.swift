import UIKit

class BuildingViewController: UIPageViewController {

	var building: Building?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}
}

extension BuildingViewController /* UIPageViewControllerDataSource */ {
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		guard let storyboard = storyboard, viewController = storyboard.instantiateViewControllerWithIdentifier("StoryViewControllerStoryboardIdentifier") as? StoryViewController else { return nil }
		return viewController
	}
}
