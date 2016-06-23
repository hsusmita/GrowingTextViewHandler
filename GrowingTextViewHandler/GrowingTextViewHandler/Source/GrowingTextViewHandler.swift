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
	public var heightChangeAnimationDuration = 0.5
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

	private var textViewHeightConstraint: NSLayoutConstraint?

	/**
		The minumum height of the textView
	*/
	private var initialHeight: CGFloat = 0.0

	/**
		The maximum height of the textView upto which it should grow and start scrolling
	*/
	private var maximumHeight: CGFloat = 0.0

	/**
		This denotes the line height of single line of characters. This value depends on the font size.
	*/
	private var caretHeight: CGFloat {
		if let selectedTextRange = growingTextView.selectedTextRange {
			return growingTextView.caretRectForPosition(selectedTextRange.end).size.height
		} else {
			return 0.0
		}
	}
	/**
		This gives the total height of the textView based on the text present in it
	*/
	private var currentHeight: CGFloat {
		guard let textViewFont = growingTextView.font else {
			return 0.0
		}
		let width = growingTextView.bounds.size.width - 2.0 * growingTextView.textContainer.lineFragmentPadding
		let boundingRect = growingTextView.text.boundingRectWithSize(CGSizeMake(width, CGFloat.max),
		options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: textViewFont], context: nil)
		let heightByBoundingRect = CGRectGetHeight(boundingRect) + textViewFont.lineHeight
		return max(heightByBoundingRect, growingTextView.contentSize.height)
	}

	/**
		This gives the number of lines based on the text present in it
	*/
	private var currentNumberOfLines: Int {
		let totalHeight = currentHeight + growingTextView.textContainerInset.top + growingTextView.textContainerInset.bottom
		return Int(totalHeight/caretHeight) - 1
	}

	// MARK:- Public methods

	/**
		Initializes and returns an instance GrowingTextViewHandler

		- parameters:
			- textView: The textView which is to be resized as the text changes
			- heightConstraint: The heightConstraint of the textView, which is altered based on size of the content of the textView
	*/
 	public init(textView: UITextView, heightConstraint: NSLayoutConstraint) {
		super.init()
		growingTextView = textView
		textViewHeightConstraint = heightConstraint
		updateInitialHeightAndResize()
	}
	/**
		Resizes the text view
		This method needs to be called in the method **textViewDidChange(textView: UITextView)**
		
		- parameters:
			- animated: If set as true, the height change will be animated
	*/
	public func resizeTextView(animated animated: Bool) {
		let textViewNumberOfLines = currentNumberOfLines
		var verticalAlignmentConstant: CGFloat = 0.0
		if textViewNumberOfLines <= minimumNumberOfLines {
		verticalAlignmentConstant = initialHeight
		} else if (textViewNumberOfLines > minimumNumberOfLines) && (textViewNumberOfLines <= maximumNumberOfLines) {
			verticalAlignmentConstant = max(currentHeight, initialHeight)
		} else if textViewNumberOfLines > maximumNumberOfLines {
			verticalAlignmentConstant = maximumHeight
		}
		if let heightConstraint = textViewHeightConstraint where heightConstraint.constant != verticalAlignmentConstant {
			updateVerticalAlignmentWithHeight(verticalAlignmentConstant, animated: animated)
		}
		if textViewNumberOfLines <= maximumNumberOfLines {
			growingTextView.setContentOffset(CGPoint.zero, animated: true)
		}
	}

	/**
		This method sets the text of the textView as well as updates the height of textView based on the content size

		- parameters:
			- animated: If set as true, the height change will be animated
	*/

	public func setText(text: String, animated: Bool) {
		self.growingTextView.text = text
		if text.characters.isEmpty {
			updateVerticalAlignmentWithHeight(self.initialHeight, animated: animated)
		} else {
			resizeTextView(animated: animated)
		}
	}

	// MARK: - Private Helpers

	/**
		This method initialzes the variables intialHeight and maximum height and performs initial resize
	*/

	private func updateInitialHeightAndResize() {
		initialHeight = estimatedInitialHeight()
		maximumHeight = estimatedMaximumHeight()
		resizeTextView(animated: false)
	}
	/**
		This method gives the estimated value for the initial height of the textView.

		- returns:
		The method caluclates the height based on minimumNumberOfLines and caretHeight, compares with current height of textView
		and returns the maximum of two.
	*/

	private func estimatedInitialHeight() -> CGFloat {
		let totalHeight = caretHeight * CGFloat(minimumNumberOfLines) + growingTextView.textContainerInset.top
		+ growingTextView.textContainerInset.bottom
		return fmax(totalHeight, CGRectGetHeight(growingTextView.frame))
	}

	/**
		This method gives the estimated value for the maximum height upto which the textView can grow
		
		maximumNumberOfLines and caretHeight are the factors which determine the maximum height of the textView
	*/

	private func estimatedMaximumHeight() -> CGFloat {
		let totalHeight = caretHeight * CGFloat(maximumNumberOfLines) + growingTextView.textContainerInset.top
		+ growingTextView.textContainerInset.bottom
		return totalHeight
	}

	/**
		This method updated the height constraint of the textView
		
		- parameters:
			- height: The desired height of the textView
			- animated: If set as true, the height change will be animated
	*/

	private func updateVerticalAlignmentWithHeight(height: CGFloat, animated: Bool) {
		guard let heightConstraint = textViewHeightConstraint else {
			return
		}
		heightConstraint.constant = height
		if (animated == true) {
			UIView.animateWithDuration(heightChangeAnimationDuration, animations: {
				self.growingTextView.superview?.layoutIfNeeded()
				}, completion: nil)
		} else {
			growingTextView.superview?.layoutIfNeeded()
		}
	}
}
