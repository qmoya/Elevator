import UIKit

class ElevatorViewController: UIViewController {

	var didTapShowStories: () -> () = {}

	@IBAction func showStories(sender: AnyObject) {
		didTapShowStories()
	}
}
