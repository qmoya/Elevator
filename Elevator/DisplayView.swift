import UIKit
import ElevatorKit

class DisplayView: UIView {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	@IBOutlet weak var label: UILabel!

	struct ViewData {
		let text: String
	}

	var viewData: ViewData? {
		didSet {
			label.text = viewData?.text
		}
	}
}

extension DisplayView.ViewData {
	init(externalPanel: ExternalPanel) {
		text = externalPanel.displayedText
	}
}
