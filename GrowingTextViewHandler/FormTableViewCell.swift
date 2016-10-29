//
//  FormTableViewCell.swift
//  GrowingTextViewHandler
//
//  Created by Susmita Horrow on 08/08/16.
//  Copyright © 2016 hsusmita.com. All rights reserved.
//

import UIKit
import GrowingTextViewHandler

protocol FormTableViewCellDelegate {
	func formTableViewCell(_ formTableViewCell: FormTableViewCell, shouldChangeHeight height: CGFloat)
}

class FormTableViewCell: UITableViewCell {
	@IBOutlet weak var textView: UITextView!
	fileprivate var handler: GrowingTextViewHandler?
	var delegate: FormTableViewCellDelegate?
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
		handler = GrowingTextViewHandler(textView: self.textView, heightConstraint: self.heightConstraint)
		handler?.minimumNumberOfLines = 2
		handler?.maximumNumberOfLines = 6
		handler?.setText("", animated: false)
//		handler?.setText("Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

	func textViewDidChange(_ textView: UITextView) {
		let oldFrame = textView.frame
		self.handler?.resizeTextView(true)
		let currentFrame = textView.frame
		if oldFrame.height != currentFrame.height {
			delegate?.formTableViewCell(self, shouldChangeHeight: textView.frame.height)
		}
	}
}
