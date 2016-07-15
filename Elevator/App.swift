import UIKit

final class App {

	let storyboard = UIStoryboard(name: "Main", bundle: nil)

	let navigationController: UINavigationController

	init(window: UIWindow) {
		guard let navigationController = window.rootViewController as? UINavigationController, buildingViewController = navigationController.viewControllers[0] as? BuildingViewController else {
			fatalError("unexpected initial view controllers")
		}

		self.navigationController = navigationController
	}
}
