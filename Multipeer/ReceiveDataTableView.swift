//
//  ReceiveDataTableView.swift
//  Multipeer
//
//  Created by Kato Masaya on 5/27/15.
//  Copyright (c) 2015 Kato Masaya. All rights reserved.
//

import UIKit

class ReceiveDataTableView: UITableView {

  let cellReuseIdentifier = "ReceiveDataTableViewCell"
  
  var datas: [Message] = [] {
    didSet{
      self.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    
    registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    self.delegate = self
    self.dataSource = self
  }
}

// MARK - UITableViewDelegate, UITableViewDataSource -

extension ReceiveDataTableView: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datas.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! ReceiveDataTableViewCell
    cell.message = datas[indexPath.row]
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return ReceiveDataTableViewCell.height()
  }
}
