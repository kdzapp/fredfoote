//
//  InterfaceController.swift
//  noteswatch Extension
//
//  Created by Kyle Zappitell on 7/8/16.
//  Copyright © 2016 Kyle Zappitell. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession!
    @IBOutlet var sendButton: WKInterfaceButton!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    @IBAction func test() {
        print("called")
        presentTextInputControllerWithSuggestions(nil, allowedInputMode: .Plain) { (text) in
            if(text != nil) {
                if let message: String? = text![0] as? String {
                    let messageToSend = ["Value":message!]
                    self.sendData(messageToSend)
                }
            }
        }
    }
    
    func sessionWatchStateDidChange(session: WCSession) {
        print("SessionWatchStateDidChange")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    override func didAppear() {
        super.didAppear()
        
        let seconds = 0.5
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.test()
        })
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sendData(data: [String:String]) {
        print("WCSession is reachabe: \(WCSession.defaultSession().reachable)")
        session.sendMessage(data, replyHandler: { replyMessage in
            //handle and present the message on screen
            let value = replyMessage["Value"] as? String
            print(value)
            }, errorHandler: {error in
                // catch any errors here
                print(error)
        })
    }

}
