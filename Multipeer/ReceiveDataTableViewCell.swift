//
//  ReceiveDataTableViewCell.swift
//  Multipeer
//
//  Created by Kato Masaya on 5/27/15.
//  Copyright (c) 2015 Kato Masaya. All rights reserved.
//

import UIKit

class ReceiveDataTableViewCell: UITableViewCell {
  
  @IBOutlet var messageLabel: UILabel!
  @IBOutlet var infoLable: UILabel!
  
  var message: Message? = nil {
    willSet {
      if newValue != nil {
        messageLabel.text = newValue!.message
        infoLable.text = "\(newValue!.displayName) \(newValue!.dateString)"
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  class func height() -> CGFloat {
    return 60.0
  }
  
}
