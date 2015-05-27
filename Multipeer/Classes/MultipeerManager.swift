//
//  MultipeerManager.swift
//  Multipeer
//
//  Created by Kato Masaya on 5/9/15.
//  Copyright (c) 2015 Kato Masaya. All rights reserved.
//
import Foundation
import MultipeerConnectivity

private let _singleton = MultipeerManager()

class MultipeerManager: NSObject {
  
  private override init() {}
  class func connectivity() -> MultipeerManager { return _singleton }
  
  var peerControl: PeerControl? = nil
  var didReceiveData:((data: NSData, fromPeerId: MCPeerID)->Void)?
  
  func buildPeerControl(#serviceType: String, displayName: String) {
    peerControl = PeerControl(serviceType: serviceType, displayName: displayName)
    peerControl!.didReceiveData = { (data: NSData, fromPeerId: MCPeerID) in
      if self.didReceiveData != nil {
        self.didReceiveData!(data: data, fromPeerId: fromPeerId)
      }
    }
  }
  
  func searchStart() {
    if peerControl != nil {
      peerControl!.start()
    } else {
      println("peerControl is null")
    }
  }
  
  func searchStop() {
    if peerControl != nil {
      peerControl!.stop()
    } else {
      println("peerControl is null")
    }
  }

  func sendData(data: NSData) -> NSError? {
    return peerControl?.sendData(data)
  }
}


class PeerControl: NSObject {
  
  var assistant: MCAdvertiserAssistant!
  var session: MCSession!
  var peerId: MCPeerID!
  var serviceTypeString: String = ""
  var sessionState: MCSessionState!
  
  var didReceiveData:((data: NSData, fromPeerId: MCPeerID)->Void)?
  
  convenience init(serviceType: String, displayName: String) {
    self.init()
    serviceTypeString = serviceType
    
    peerId = MCPeerID(displayName: displayName)
    session = MCSession(peer: peerId!, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
    session.delegate = self
    
    assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
    if assistant != nil {
      assistant!.delegate = self
    }
    sessionState = MCSessionState.NotConnected
  }
  
  func start() {
    if assistant != nil {
      assistant!.start()
    }
  }
  func stop() {
    if assistant != nil {
      assistant!.stop()
    }
  }
  
  func sendData(data: NSData) -> NSError? {
    if assistant != nil {
      var err: NSError? = nil
      assistant!.session.sendData(data, toPeers: assistant!.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &err)
      
      return err
    } else {
      return NSError(domain: "MCAdvertiserAssitant err", code: 1, userInfo: nil)
    }
  }
  
  func buildBrowserViewControlleWithDelegate(delegate: MCBrowserViewControllerDelegate) -> MCBrowserViewController {
    let browserViewController = MCBrowserViewController(serviceType: serviceTypeString, session: session)
    browserViewController.delegate = delegate
    browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers
    browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers
    return browserViewController
  }
}

// MARK: - MCSessionDelegate Methods -

extension PeerControl:  MCSessionDelegate{
  
  // MCSessionDelegate
  func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
  }
  
  func session(session: MCSession!, didReceiveCertificate certificate: [AnyObject]!, fromPeer peerID: MCPeerID!, certificateHandler: ((Bool) -> Void)!) {
    certificateHandler(true)
  }
  
  func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
    if didReceiveData != nil {
      didReceiveData!(data: data, fromPeerId: peerID)
    }
  }
  
  func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
  }
  
  func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
  }
  
  func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
    sessionState = state
  }
}

// MARK: - MCAdvertiserAssistantDelegate Methods -

extension PeerControl: MCAdvertiserAssistantDelegate {
    func advertiserAssistantWillPresentInvitation(advertiserAssistant: MCAdvertiserAssistant!) {
    }
    
    func advertiserAssistantDidDismissInvitation(advertiserAssistant: MCAdvertiserAssistant!) {
        
    }
}
