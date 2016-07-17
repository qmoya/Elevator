import UIKit
import ElevatorKit

class ElevatorViewController: UIViewController {
	var cabin: Cabin?

	var didTapExit: () -> () = {}

	@IBAction func exit(sender: AnyObject) {
		didTapExit()
	}
}
