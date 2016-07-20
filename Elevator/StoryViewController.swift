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

	@IBAction func call(sender: AnyObject) {
		story?.panel.call()
	}

	@IBAction func enter(sender: AnyObject) {
		didTapEnter()
	}

	private func updateDisplayText() {
		guard let panel = story?.panel else { return }
		displayView.viewData = DisplayView.ViewData(externalPanel: panel)
	}

	private func refreshEnterButtonState() {
		guard let doors = story?.doors else { return }
		self.navigationItem.rightBarButtonItem?.enabled = doors.areOpen
	}

	private func reloadData() {
		refreshEnterButtonState()
		updateDisplayText()
	}
}

extension StoryViewController /* UIViewController */ {
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
}
