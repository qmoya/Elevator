import UIKit
import ElevatorKit

class ElevatorViewController: UIViewController {
	var elevator: Elevator?

	var didTapExit: () -> () = {}

	@IBAction func exit(sender: AnyObject) {
		didTapExit()
	}
}
