import UIKit
import ElevatorKit

final class StoryViewController: UIViewController {

	var story: Story? {
		didSet {
			navigationItem.title = story?.name
			story?.doors.delegate = self
		}
	}

	var didTapEnter: () -> () = {}

	@IBOutlet weak var displayView: DisplayView!
	
	@IBOutlet weak var backgroundImageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		backgroundImageView.image = UIImage(named: story!.backgroundImageName)
		story?.panel.displayedTextDidChange = updateDisplayText
		updateDisplayText()
		refreshEnterButtonState()
	}

	@IBAction func call(sender: AnyObject) {
		print("elevator called on the \(story?.name)")
		story?.panel.call()
	}

	func updateDisplayText() {
		guard let panel = story?.panel else { return }
		displayView.viewData = DisplayView.ViewData(externalPanel: panel)
	}

	@IBAction func enter(sender: AnyObject) {
		didTapEnter()
	}

	func refreshEnterButtonState() {
		self.navigationItem.rightBarButtonItem?.enabled = story?.doors.state == .Open
	}
}

extension StoryViewController: DoorsDelegate {
	func doorsDidChangeState(doors: Doors) {
		refreshEnterButtonState()
	}
}
