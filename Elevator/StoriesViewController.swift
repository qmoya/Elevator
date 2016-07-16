import UIKit

class StoriesViewController: UITableViewController {

	var didTapCancel: () -> () = {}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	@IBAction func cancel(sender: AnyObject) {
		didTapCancel()
	}
}
