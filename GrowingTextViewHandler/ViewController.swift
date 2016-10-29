//
//  ViewController.swift
//  GrowingTextViewHandler
//
//  Created by hsusmita on 25/02/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

import UIKit
import GrowingTextViewHandler

class ViewController: UIViewController,UITextViewDelegate {

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  var handler: GrowingTextViewHandler?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handler = GrowingTextViewHandler(textView: self.textView, heightConstraint: self.heightConstraint)
    handler?.minimumNumberOfLines = 2
    handler?.maximumNumberOfLines = 6
	handler?.setText("", animated: false)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  func textViewDidChange(_ textView: UITextView) {
    self.handler?.resizeTextView(true)
  }
}
