//
//  GrowingTextViewHandler.swift
//  GrowingTextViewHandler
//
//  Created by hsusmita on 25/02/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

import UIKit

public class GrowingTextViewHandler: NSObject {
	public var growingTextView : UITextView!
	public var animationDuration = 0.5
	public var maximumNumberOfLines = Int.max {
		didSet {
			updateInitialHeightAndResize()
		}
	}
	public var minimumNumberOfLines = 1 {
		didSet {
			updateInitialHeightAndResize()
		}
	}
	private var initialHeight: CGFloat = 0.0
	private var maximumHeight: CGFloat = 0.0
	private var heightConstraint: NSLayoutConstraint?
	private var caretHeight: CGFloat {
		if let selectedTextRange = growingTextView.selectedTextRange {
			return growingTextView.caretRectForPosition(selectedTextRange.end).size.height
		} else {
			return 0.0
		}
	}

	private var currentHeight: CGFloat {
		guard let textViewFont = growingTextView.font else {
			return 0.0
		}
		let width = growingTextView.bounds.size.width - 2.0 * growingTextView.textContainer.lineFragmentPadding
		let boundingRect = self.growingTextView.text.boundingRectWithSize(CGSizeMake(width, CGFloat.max),
		                                                                  options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: textViewFont], context: nil)
		let heightByBoundingRect = CGRectGetHeight(boundingRect) + textViewFont.lineHeight
		return max(heightByBoundingRect, growingTextView.contentSize.height)
	}

	private var currentNumberOfLines: Int {
		let totalHeight = currentHeight + self.growingTextView.textContainerInset.top + self.growingTextView.textContainerInset.bottom
		return Int(totalHeight/caretHeight) - 1
	}

	// MARK:- Public methods

	public init(textView: UITextView, heightConstraint: NSLayoutConstraint) {
		super.init()
		self.growingTextView = textView
		self.heightConstraint = heightConstraint
		updateInitialHeightAndResize()
	}

	public func resizeTextView(animated animated: Bool) {
		let textViewNumberOfLines = currentNumberOfLines
		var verticalAlignmentConstant: CGFloat = 0.0
		if textViewNumberOfLines <= self.minimumNumberOfLines {
			verticalAlignmentConstant = self.initialHeight
		} else if (textViewNumberOfLines > self.minimumNumberOfLines) && (textViewNumberOfLines <= self.maximumNumberOfLines) {
			verticalAlignmentConstant = (currentHeight > self.initialHeight) ? currentHeight : self.initialHeight
		} else if textViewNumberOfLines > self.maximumNumberOfLines {
			verticalAlignmentConstant = self.maximumHeight
		}
		if let heightConstraint = self.heightConstraint where heightConstraint.constant != verticalAlignmentConstant {
			updateVerticalAlignmentWithHeight(verticalAlignmentConstant, animated: animated)
		}
		if textViewNumberOfLines <= self.maximumNumberOfLines {
			self.growingTextView.setContentOffset(CGPoint.zero, animated: true)
		}
	}

	public func setText(text: String, animated: Bool) {
		self.growingTextView.text = text
		if text.characters.isEmpty {
			updateVerticalAlignmentWithHeight(self.initialHeight, animated: animated)
		} else {
			resizeTextView(animated: animated)
		}
	}

	// MARK: - Private Helpers

	private func updateInitialHeightAndResize() {
		self.initialHeight = estimatedInitialHeight()
		self.maximumHeight = estimatedMaximumHeight()
		resizeTextView(animated: false)
	}

	private func estimatedInitialHeight() -> CGFloat {
		let totalHeight = caretHeight * CGFloat(self.minimumNumberOfLines) + self.growingTextView.textContainerInset.top
			+ self.growingTextView.textContainerInset.bottom
		return fmax(totalHeight,self.growingTextView.frame.size.height)
	}

	private func estimatedMaximumHeight() -> CGFloat {
		let totalHeight = caretHeight * CGFloat(self.maximumNumberOfLines) + self.growingTextView.textContainerInset.top
			+ self.growingTextView.textContainerInset.bottom
		return totalHeight
	}

	private func updateVerticalAlignmentWithHeight(height: CGFloat, animated: Bool) {
		guard let heightConstraint = self.heightConstraint else {
			return
		}
		heightConstraint.constant = height
		if (animated == true) {
			UIView.animateWithDuration(self.animationDuration, animations: {
				self.growingTextView.superview?.layoutIfNeeded()
				}, completion: nil)
		} else {
			self.growingTextView.superview?.layoutIfNeeded()
		}
	}
}
