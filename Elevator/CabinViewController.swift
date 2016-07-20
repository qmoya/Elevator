import UIKit
import ElevatorKit

class CabinViewController: UIViewController {
	var cabin: Cabin? {
		didSet {
			cabin?.didChangeState = refresh
		}
	}

	var panel: CabinPanel? {
		didSet {
			guard let panel = panel else { return }
			panel.displayedTextDidChange = updateDisplayView
			panel.janitorModeDidChange = updateSelectionOfJanitorButton
			panel.janitorModeAvailabilityDidChange = updateEnablementOfJanitorButton
		}
	}

	var didTapExit: () -> () = {}
	
	@IBOutlet weak var displayView: DisplayView!

	@IBOutlet weak var janitorButton: UIButton!

	@IBAction func toggleJanitorModeWithSender(sender: AnyObject) {
		panel?.toggleJanitorMode()
	}
	
	@IBAction func exit(sender: AnyObject) {
		didTapExit()
	}

	@IBAction func goToBasementWithSender(sender: AnyObject) {
		call(0)
	}

	@IBAction func goToGroundFloorWithSender(sender: AnyObject) {
		call(1)
	}

	@IBAction func goToFirstFloorWithSender(sender: AnyObject) {
		call(2)
	}

	@IBAction func goToSecondFloorWithSender(sender: AnyObject) {
		call(3)
	}

	@IBAction func goToThirdFloorWithSender(sender: AnyObject) {
		call(4)
	}

	@IBAction func goToFourthFloorWithSender(sender: AnyObject) {
		call(5)
	}

	@IBAction func goToFifthFloorWithSender(sender: AnyObject) {
		call(6)
	}

	@IBAction func goToSixthFloorWithSender(sender: AnyObject) {
		call(7)
	}
	
	private func call(level: Level) {
		guard let panel = panel else { return }
		panel.call(level)
	}
	
	private func updateExitButton() {
		print("updating exit button for \(cabin?.doors?.state == .Open)")
		navigationItem.rightBarButtonItem?.enabled = cabin?.doors?.state == .Open
	}
	
	private func updateDisplayView() {
		guard let panel = panel else { return }
		displayView.viewData = DisplayView.ViewData(cabinPanel: panel)
	}
	
	private func updateEnablementOfJanitorButton() {
		guard let panel = panel else { return }
		janitorButton.enabled = panel.isJanitorModeAvailable
	}
	
	private func updateSelectionOfJanitorButton() {
		guard let panel = panel else { return }
		janitorButton.selected = panel.isJanitorModeEnabled
	}
	
	private func refresh() {
		cabin?.doors?.didChangeInteriorState = updateExitButton
		updateDisplayView()
		updateEnablementOfJanitorButton()
		updateSelectionOfJanitorButton()
	}
}

extension CabinViewController /* UIViewController */ {
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		refresh()
	}
}
