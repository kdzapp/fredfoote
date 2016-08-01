//
//  ViewController.swift
//  notes
//
//  Created by Kyle Zappitell on 7/6/16.
//  Copyright © 2016 Kyle Zappitell. All rights reserved.
//

import UIKit
import WatchConnectivity
import CoreData

class ViewController: UIViewController,  WCSessionDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    var session: WCSession!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var emailCD = createManagedObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        
        //Intialize as Email Keyboard, No AutoCorrect
        emailText.keyboardType = .EmailAddress
        emailText.autocorrectionType = .No
        
    }
    
    @IBAction func setEmailButton(sender: AnyObject) {
        saveEmail(emailText.text!)
        print(emailCD.valueForKey("email") as? String)
        emailLabel.text! = "Set Email!"
    }
    
    @IBAction func buttonPush(sender: AnyObject) {
        let message: String = textView.text
        sendEmail(message, email: emailCD.valueForKey("email") as? String)
        if let emailSent = emailCD.valueForKey("email") as? String {
            emailLabel.text! = "Sending email to " + emailSent + "..."
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //handle received message
        let value = message["Value"] as! String
        //use this to present immediately on the screen
        
        let request = NSFetchRequest(entityName: "Emaildata")
        let managedContext = appDelegate.managedObjectContext
        do {
            let result = try managedContext.executeFetchRequest(request)
            let defaultEmail = (result[0] as! NSManagedObject).valueForKey("email") as! String
            dispatch_async(dispatch_get_main_queue()) {
                sendEmail(value, email: defaultEmail)
            }
        } catch {
            print("Failed to fetch email: \(error)")
        }
        //send a reply
        replyHandler(["Value":"Yes"])
    }
    
    func saveEmail(emailStr: String) {
        
        let managedContext = appDelegate.managedObjectContext
        
        let entityDescription = NSEntityDescription.entityForName("Emaildata", inManagedObjectContext: managedContext)
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        do {
            let result = try managedContext.executeFetchRequest(request)
            for data in result {
                (data as! NSManagedObject).setValue(emailStr, forKey: "email")
            }

            do {
                try managedContext.save()
                print("saved")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

}

func sendEmail(message: String, email: String?) {
    
    let smtpSession: MCOSMTPSession = MCOSMTPSession()
    smtpSession.hostname = "smtp.gmail.com"
    smtpSession.port = 465
    smtpSession.username = "prokdzsnake@gmail.com"
    smtpSession.password = "sake1997"
    smtpSession.connectionType = MCOConnectionType.TLS
    
    let builder: MCOMessageBuilder = MCOMessageBuilder()
    builder.header.from = MCOAddress.init(mailbox: smtpSession.username)
    
    //Test Recipient
    let address: MCOAddress
    if(email != nil) {
        address = MCOAddress(mailbox: email)
    } else {
        address = MCOAddress(mailbox: "kdzapp@umich.edu")
    }
    
    var addressList = [AnyObject]()
    addressList.append(address)
    builder.header.to = addressList
    builder.header.subject = message
    
    let rfc822Data: NSData = builder.data()
    let sendOperation: MCOSMTPSendOperation = smtpSession.sendOperationWithData(rfc822Data)
    sendOperation.start({(error: NSError?) -> Void in
        if (error != nil) {
            print("\(smtpSession.username) Error sending email:\(error)")
        }
        else {
            print("\(smtpSession.username) Successfully sent email!")
            UIControl().sendAction(#selector(NSURLSessionTask.suspend), to: UIApplication.sharedApplication(), forEvent: nil)
        }
    })
}

func createManagedObject() -> NSManagedObject {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let entity =  NSEntityDescription.entityForName("Emaildata", inManagedObjectContext:managedContext)
    let email = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    
    return email
}

