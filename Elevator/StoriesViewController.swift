import UIKit
import ElevatorKit

class StoriesViewController: UIPageViewController {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		dataSource = self
		delegate = self
	}

	var storyViewControllerAboveStoryViewController: (StoryViewController) -> (StoryViewController?) = { _ in return nil }

	var storyViewControllerBelowStoryViewController: (StoryViewController) -> (StoryViewController?) = { _ in return nil }

	var storyViewController: StoryViewController {
		set {
			setViewControllers([newValue], direction: .Forward, animated: false, completion: nil)
			updateNavigationBarForStoryViewController(newValue)
		}
		get {
			guard let viewControllers = viewControllers, last = viewControllers.last as? StoryViewController else {
				fatalError("couldn't get story view controller")
			}
			return last
		}
	}

	private func updateNavigationBarForStoryViewController(storyViewController: StoryViewController) {
		navigationItem.title = storyViewController.navigationItem.title
		navigationItem.rightBarButtonItem = storyViewController.navigationItem.rightBarButtonItem
	}
}

extension StoriesViewController: UIPageViewControllerDataSource {
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		guard let storyViewController = viewController as? StoryViewController else { return nil }
		return storyViewControllerBelowStoryViewController(storyViewController)
	}

	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		guard let storyViewController = viewController as? StoryViewController else { return nil }
		return storyViewControllerAboveStoryViewController(storyViewController)
	}
}

extension StoriesViewController: UIPageViewControllerDelegate {
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if !completed { return }
		updateNavigationBarForStoryViewController(storyViewController)
	}
}
