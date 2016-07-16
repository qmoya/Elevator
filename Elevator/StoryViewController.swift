import UIKit
import ElevatorKit

final class StoryViewController: UIViewController {

	var story: Story? {
		didSet {
			navigationItem.title = story?.name
		}
	}

	var didTapEnter: () -> () = {}

	var elevatorController: ElevatorController?

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enter", style: .Plain, target: self, action: #selector(enter))

	}

	func enter(sender: AnyObject) {
		didTapEnter()
	}

	@IBAction func call(sender: AnyObject) {
		print("elevator called on the \(story?.name)")
		elevatorController?.call(from: self.story!)
	}
}
