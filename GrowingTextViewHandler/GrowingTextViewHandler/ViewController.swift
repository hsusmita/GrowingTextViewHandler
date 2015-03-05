//
//  ViewController.swift
//  GrowingTextViewHandler
//
//  Created by hsusmita on 25/02/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextViewDelegate {

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  var handler:GrowingTextViewHandler?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handler = GrowingTextViewHandler(textView: self.textView, heightConstraint: self.heightConstraint)
    handler?.minimumNumberOfLines = 2
    handler?.maximumNumberOfLines = 6
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func textViewDidChange(textView: UITextView) {
    self.handler?.resizeTextView(animated:true)
  }
}

