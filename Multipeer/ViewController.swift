//
//  ViewController.swift
//  Multipeer
//
//  Created by Kato Masaya on 5/9/15.
//  Copyright (c) 2015 Kato Masaya. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
  
  @IBOutlet var sendTextFeild: UITextField!
  @IBOutlet var receiveDataTableView: ReceiveDataTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildPeerManager()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func searchBtnTapped(sender: AnyObject) {
    if let _peerControl = MultipeerManager.connectivity().peerControl {
      let viewController = _peerControl.buildBrowserViewControlleWithDelegate(self)
      self.presentViewController(viewController, animated: true, completion: nil)
    }
  }
  
  @IBAction func sendBtnTapped(sender: AnyObject) {
    if let sendText = sendTextFeild.text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
      if let err = MultipeerManager.connectivity().sendData(sendText) {
        println("Send err: \(err)")
      } else {
        sendTextFeild.text = ""
        sendTextFeild.resignFirstResponder()
        
        let displayName = UIDevice.currentDevice().name
        let messageObj = Message(message: sendTextFeild.text, displayName:displayName, dateString: self.dateString())
        receiveDataTableView.datas.insert(messageObj, atIndex: 0)
      }
    } else {
      println("Error")
    }
  }
  
  private func buildPeerManager() {
    let serviceType = "Test-Peer"
    let displayName = UIDevice.currentDevice().name
    
    let peerMgr = MultipeerManager.connectivity()
    peerMgr.buildPeerControl(serviceType: serviceType, displayName: displayName)
    peerMgr.searchStart()
    peerMgr.didReceiveData = { [unowned self](data: NSData, fromPeer: MCPeerID) in
      if let dataString = NSString(data: data, encoding: NSUTF8StringEncoding) {
        let messageObj = Message(message: dataString as String, displayName: fromPeer.displayName, dateString: self.dateString())
        dispatch_async(dispatch_get_main_queue(), {
          self.receiveDataTableView.datas.insert(messageObj, atIndex: 0)
        })
      }
    }
  }
  
  private func dateString() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MM/dd HH時mm分"
    return formatter.stringFromDate(NSDate())
  }
}


// MARK: - MCBrowserViewControllerDelegate -

extension ViewController: MCBrowserViewControllerDelegate {
  func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
    browserViewController.dismissViewControllerAnimated(true, completion: nil)
  }
  func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
    browserViewController.dismissViewControllerAnimated(true, completion: nil)
    
  }
}

// MARK: - UITextFieldDelegate -

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    sendTextFeild.resignFirstResponder()
    return true
  }
}

