//
//  GrowingTextViewHandler.swift
//  GrowingTextViewHandler
//
//  Created by hsusmita on 25/02/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

import UIKit

public enum TextGrowthDirection {
  case Up, Down, Both
}

class GrowingTextViewHandler: NSObject {
  
  var growthDirection : TextGrowthDirection = TextGrowthDirection.Up
  var growingTextView : UITextView!
  var maximumNumberOfLines = 10
  var minimumNumberOfLines : NSInteger = 1 {
    didSet {
      minimumNumberOfLines =  min(minimumNumberOfLines,estimatedMinimumNumberOfLines())
      initialHeight = estimatedInitialHeight()
    }
  }
  private var textViewFont: UIFont = UIFont(name: "Helvetica", size: 17)!
  private var initialHeight: CGFloat! = 10.0;
  
  private var verticalConstraint: NSLayoutConstraint!
  
  init(textView:UITextView,superView:UIView,growthDirection:TextGrowthDirection) {
    super.init()
    self.growingTextView = textView
    self.growthDirection = growthDirection
    
//    self.addPropertyObserver()
    self.maximumNumberOfLines = 10
    self.minimumNumberOfLines = 2
    self.textViewFont = UIFont(name: "Helvetica", size: 17)!
    self.initialHeight = estimatedInitialHeight()
    checkForMissingConstraints(self.growingTextView.superview!)
    resizeTextView(false)
  }
  
  private func estimatedInitialHeight() -> (CGFloat) {
    var estimatedHeight = self.textViewFont.lineHeight * CGFloat(self.minimumNumberOfLines + 1)
    return max(estimatedHeight,self.growingTextView.frame.size.height)
  }
  
  private func estimatedMinimumNumberOfLines() -> (NSInteger) {
    var totalHeight: CGFloat = self.growingTextView.frame.size.height
    return Int(ceil(totalHeight / self.textViewFont.lineHeight))
  }
  
  private func currentHeight() -> (CGFloat) {
    return (self.growingTextView.contentSize.height + self.growingTextView.font.lineHeight)
  }
  
  private func currentNumberOfLines() -> (NSInteger) {
    var totalHeight: CGFloat = self.growingTextView.contentSize.height
    return Int( self.growingTextView.contentSize.height / self.textViewFont.lineHeight)
  }
  
  private func resizeTextView(animated:Bool) {
    var textViewNumberOfLines = self.currentNumberOfLines()
    if (textViewNumberOfLines <= self.minimumNumberOfLines) {
      self.updateVerticalAlignment(self.initialHeight,animated: animated)
    }else if ((textViewNumberOfLines > self.minimumNumberOfLines) && (textViewNumberOfLines < self.maximumNumberOfLines)) {
      var currentHeight = self.currentHeight()
      var verticalAlignmentConstant = (currentHeight > self.initialHeight) ? currentHeight : self.initialHeight
      self.updateVerticalAlignment(verticalAlignmentConstant, animated: animated)
    }
  }
  
  private func updateVerticalAlignment(height:CGFloat, animated:Bool) {
    self.verticalConstraint.constant = height
    if (animated == true) {
      let animationDuration : NSTimeInterval = 1.0
      UIView.animateWithDuration(animationDuration,
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
  
  private func checkForMissingConstraints(superView:UIView) -> () {
    var requiredConstraintPresent: Bool = false
    weak var topConstraint: NSLayoutConstraint?
    weak var height:NSLayoutConstraint?
    
    let constraints = superView.constraints() as NSArray
    var predicate = NSPredicate ({ (object:AnyObject!, [NSObject : AnyObject]!) -> Bool in
      var constraint : NSLayoutConstraint = object as NSLayoutConstraint
      return (constraint.firstItem.isEqual(self.growingTextView) == true || constraint.secondItem?.isEqual(self.growingTextView) == true)
    })
    
    var constraintsOnSelf: NSArray = constraints.filteredArrayUsingPredicate(predicate)
    
    var index = constraintsOnSelf.indexOfObjectPassingTest { (object:AnyObject!, Index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Bool in
      var constraint : NSLayoutConstraint = object as NSLayoutConstraint
      return self.isRequiredConstraint(constraint)
    }
    
    if (index == NSNotFound) {
      self.showErrorForRequiredMissing()
    }
    
    predicate = NSPredicate ({ (object:AnyObject!, [NSObject : AnyObject]!) -> Bool in
      var constraint : NSLayoutConstraint = object as NSLayoutConstraint
      return (self.isHeightConstraint(constraint))
    })
//    print("con = \(self.growingTextView.constraints())");
    var result:NSArray = (self.growingTextView.constraints() as NSArray).filteredArrayUsingPredicate(predicate)
    if (result.count == 0) {
      println("Add Height constraint")
    }else {
      self.verticalConstraint = result.firstObject as NSLayoutConstraint
    }
  }
  
  private func showErrorForRequiredMissing() -> () {
    switch(self.growthDirection) {
      
    case TextGrowthDirection.Up:
      println("Add Bottom Constraint to grow text view upwards")
      
    case TextGrowthDirection.Down:
      println("Add Top Constraint to grow text view downwards")
      
    case TextGrowthDirection.Both:
      println("Add Center Y Constraint to grow text view both up and down")
      
    default:
      println()
    }
    
  }
  
  private func isRequiredConstraint(constraint:NSLayoutConstraint)->(Bool) {
    var result : Bool
    switch(self.growthDirection) {
    case TextGrowthDirection.Up:
      result = self.isBottomVerticalConstraint(constraint)
      
    case TextGrowthDirection.Down:
      result = self.isTopVerticalConstraint(constraint)
      
    case TextGrowthDirection.Both:
      result = self.isCenterConstraint(constraint)
      
    default:
      return true
    }
    return result
  }
  
  private func isVerticalConstraint(constraint:NSLayoutConstraint) -> (Bool) {
    var result : Bool
    switch(self.growthDirection) {
    case TextGrowthDirection.Up:
      result = self.isTopVerticalConstraint(constraint)
      
    case TextGrowthDirection.Down:
      result = self.isBottomVerticalConstraint(constraint)
      
    case TextGrowthDirection.Both:
      result = self.isCenterConstraint(constraint)
      
    default:
      return true
    }
    return result
  }
  
  func isTopVerticalConstraint(constraint:NSLayoutConstraint) -> (Bool) {
    var selfAttribute : NSLayoutAttribute = (constraint.firstItem.isEqual(self.growingTextView) == true) ? constraint.firstAttribute :constraint.secondAttribute
    return ((selfAttribute == NSLayoutAttribute.Top) ||
      (selfAttribute == NSLayoutAttribute.TopMargin))
  }
  
  func isBottomVerticalConstraint(constraint:NSLayoutConstraint) -> (Bool) {
    var selfAttribute : NSLayoutAttribute = (constraint.firstItem.isEqual(self.growingTextView) == true) ? constraint.firstAttribute :constraint.secondAttribute
    return ((selfAttribute == NSLayoutAttribute.Bottom) || (selfAttribute == NSLayoutAttribute.BottomMargin))
  }
  
  func isCenterConstraint(constraint:NSLayoutConstraint) -> (Bool) {
    var selfAttribute : NSLayoutAttribute = (constraint.firstItem.isEqual(self.growingTextView) == true) ? constraint.firstAttribute :constraint.secondAttribute
    return ((selfAttribute == NSLayoutAttribute.CenterY) || (selfAttribute == NSLayoutAttribute.CenterYWithinMargins))
  }
  
  func isHeightConstraint(constraint:NSLayoutConstraint) -> (Bool) {
    var selfAttribute : NSLayoutAttribute = (constraint.firstItem.isEqual(self.growingTextView) == true) ? constraint.firstAttribute :constraint.secondAttribute
    return selfAttribute == NSLayoutAttribute.Height
  }
  
  private func addPropertyObserver()->() {
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resize"), name: UITextViewTextDidChangeNotification, object: nil)
  }
  
   func resize() -> (){
    self.resizeTextView(true)
    self.growingTextView.layoutSubviews()
  }
}
