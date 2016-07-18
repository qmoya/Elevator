import UIKit
import ElevatorKit

class BuildingViewController: UIPageViewController {

	var didChangeStoryViewController: (StoryViewController) -> () = { _ in }

	var storyViewControllerAboveStoryViewController: (StoryViewController) -> (StoryViewController?) = { _ in return nil }

	var storyViewControllerBelowStoryViewController: (StoryViewController) -> (StoryViewController?) = { _ in return nil }

	var initialStoryViewController: () -> (StoryViewController) = { _ in return StoryViewController() } // TODO: Perhaps should be simply a variable

	override func viewDidLoad() {
		super.viewDidLoad()
		let initial = initialStoryViewController()
		setViewControllers([initialStoryViewController()], direction: .Forward, animated: true, completion: nil)
		didChangeStoryViewController(initial)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		dataSource = self // TODO: can't set it in the storyboard — check why
		delegate = self
	}
}

extension BuildingViewController: UIPageViewControllerDataSource {
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		guard let storyViewController = viewController as? StoryViewController else { return nil }
		return storyViewControllerBelowStoryViewController(storyViewController)
	}

	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		guard let storyViewController = viewController as? StoryViewController else { return nil }
		return storyViewControllerAboveStoryViewController(storyViewController)
	}
}

extension BuildingViewController: UIPageViewControllerDelegate {
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if !completed { return }
		if let viewControllers = viewControllers, last = viewControllers.last as? StoryViewController {
			didChangeStoryViewController(last)
		}
	}
}
