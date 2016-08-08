//
//  FormViewController.swift
//  GrowingTextViewHandler
//
//  Created by Susmita Horrow on 08/08/16.
//  Copyright © 2016 hsusmita.com. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.estimatedRowHeight = 50.0
		tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension FormViewController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("FormTableViewCellIdentifier") as? FormTableViewCell
		cell?.delegate = self
		return cell!
	}
}

extension FormViewController: FormTableViewCellDelegate {
	func formTableViewCell(formTableViewCell: FormTableViewCell, shouldChangeHeight height: CGFloat) {
		tableView.beginUpdates()
		tableView.endUpdates()
	}
}