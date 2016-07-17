import UIKit
import ElevatorKit

final class StoryViewController: UIViewController {

	var story: Story? {
		didSet {
			guard let story = story else { return }
			navigationItem.title = story.name
			backgroundImageView.image = UIImage(named: story.backgroundImageName)
		}
	}

	var didTapEnter: () -> () = {}

	var elevatorController: ElevatorController?

	@IBOutlet weak var backgroundImageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enter", style: .Plain, target: self, action: #selector(enter))

	}

	func enter(sender: AnyObject) {
		didTapEnter()
	}

	@IBAction func call(sender: AnyObject) {
		print("elevator called on the \(story?.name)")
		story?.panel.call()
	}
}
