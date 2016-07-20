import UIKit
import ElevatorKit

final class StoryViewController: UIViewController {

	var story: Story? {
		didSet {
			navigationItem.title = story?.name
		}
	}

	var didTapEnter: () -> () = {}

	@IBOutlet weak var displayView: DisplayView!
	
	@IBOutlet weak var backgroundImageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		backgroundImageView.image = UIImage(named: story!.backgroundImageName)
		story?.panel.displayedTextDidChange = updateDisplayText
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		story?.doors.didChangeExteriorState = refreshEnterButtonState
		reloadData()
	}

	@IBAction func call(sender: AnyObject) {
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
	
	func reloadData() {
		refreshEnterButtonState()
		updateDisplayText()
	}
}
