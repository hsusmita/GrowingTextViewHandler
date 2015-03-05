//
//  GrowingTextViewHandler.swift
//  GrowingTextViewHandler
//
//  Created by hsusmita on 25/02/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

import UIKit

public class GrowingTextViewHandler: NSObject, UIScrollViewDelegate {
  
  public var growingTextView : UITextView!
  public var animationDuration = 0.8
  public var maximumNumberOfLines = 10
  public var minimumNumberOfLines : NSInteger = 1 {
    didSet {
      initialHeight = estimatedInitialHeight()
      resizeTextView(animated: false)
    }
  }
  private var initialHeight: CGFloat! = 0.0;
  private var heightConstraint: NSLayoutConstraint!
  
  init(textView:UITextView,heightConstraint:NSLayoutConstraint) {
    super.init()
    self.growingTextView = textView
    self.heightConstraint = heightConstraint
  }

  private func estimatedInitialHeight() -> (CGFloat) {
    var font = growingTextView.font
    var adjust = (font.ascender - font.capHeight)
    var estimatedHeight = font.lineHeight * CGFloat(self.minimumNumberOfLines)
    var height = self.growingTextView.caretRectForPosition(self.growingTextView.selectedTextRange?.end).height
    var totalHeight = height * CGFloat(self.minimumNumberOfLines) + self.growingTextView.textContainerInset.top + self.growingTextView.textContainerInset.bottom
    return max(totalHeight,self.growingTextView.frame.size.height)
  }
  
  private func estimatedMinimumNumberOfLines() -> (NSInteger) {
    var totalHeight: CGFloat = self.growingTextView.frame.size.height
    return Int(ceil(totalHeight /  self.growingTextView.font.lineHeight))
  }
  
  private func currentHeight() -> (CGFloat) {
    return self.growingTextView.contentSize.height
  }
  
  private func currentNumberOfLines() -> (NSInteger) {
    return Int( self.growingTextView.contentSize.height / self.growingTextView.font.lineHeight)
  }
  
  private func updateVerticalAlignment(height:CGFloat, animated:Bool) {
    self.heightConstraint.constant = height
   if (animated == true) {
        UIView.animateWithDuration(self.animationDuration,
        animations: {
          ()->() in
          self.growingTextView.superview?.layoutIfNeeded()
          return
        },
        completion:{
          (animated:Bool) -> () in

      })
    }else {
      self.growingTextView.superview?.layoutIfNeeded()
    }
  }
  
  public func resizeTextView(#animated:Bool) {
    var textViewNumberOfLines = self.currentNumberOfLines();
    if (textViewNumberOfLines <= self.minimumNumberOfLines) {
      self.updateVerticalAlignment(self.initialHeight,animated: animated)
      self.growingTextView.setContentOffset(CGPointZero, animated: true)
    }else if ((textViewNumberOfLines > self.minimumNumberOfLines) && (textViewNumberOfLines <= self.maximumNumberOfLines)) {
      var currentHeight = self.currentHeight()
      var verticalAlignmentConstant = (currentHeight > self.initialHeight) ? currentHeight : self.initialHeight
      self.updateVerticalAlignment(verticalAlignmentConstant, animated: animated)
      self.growingTextView.setContentOffset(CGPointZero, animated: true)
    }
  }
}
