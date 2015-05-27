//
//  Message.swift
//  Multipeer
//
//  Created by Kato Masaya on 5/27/15.
//  Copyright (c) 2015 Kato Masaya. All rights reserved.
//

import Foundation

class Message {
  
  var message: String = ""
  var displayName: String = ""
  var dateString: String = ""
  
  convenience init(message: String, displayName: String, dateString: String) {
    self.init()
    self.message = message
    self.displayName = displayName
    self.dateString = dateString
  }
}
