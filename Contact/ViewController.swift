//
//  ViewController.swift
//  Contact
//
//  Created by Hannah McCullough on 3/9/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
//0) Add import for CoreData
import CoreData


class ViewController: UIViewController {
    
    //1) Add ManagedObject Data Context
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext
    
    //2) Add variable contactdb (used from UITableView
    var contactdb:NSManagedObject!

    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBAction func btnBack(sender: UIBarButtonItem) {
        //3) Dismiss ViewController
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func btnSave(sender: UIButton) {
        //4 Add Save Logic
        if (contactdb != nil)
        {
            
            contactdb.setValue(fullname.text, forKey: "fullname")
            contactdb.setValue(email.text, forKey: "email")
            contactdb.setValue(phone.text, forKey: "phone")
            
        }
        else
        {
            let entityDescription =
            NSEntityDescription.entityForName("Contact",
                inManagedObjectContext: managedObjectContext!)
            
            let contact = Contact(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            
            contact.fullname = fullname.text
            contact.email = email.text
            contact.phone = phone.text
        }
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            status.text = err.localizedFailureReason
        } else {
            self.dismissViewControllerAnimated(false, completion: nil)
            
        }
    }
    
    @IBAction func btnFind(sender: UIButton) {
        //5 Add Find Logic
        let entityDescription =
        NSEntityDescription.entityForName("Contact",
            inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(fullname = %@)", fullname.text)
        request.predicate = pred
        
        var error: NSError?
        
        var objects = managedObjectContext?.executeFetchRequest(request,
            error: &error)
        
        if let results = objects {
            
            if results.count > 0 {
                let match = results[0] as NSManagedObject
                
                fullname.text = match.valueForKey("fullname") as String
                email.text = match.valueForKey("email") as String
                phone.text = match.valueForKey("phone") as String
                status.text = "Matches found: \(results.count)"
            } else {
                status.text = "No Match"
            }
        }
    }
    //6 Add to hide keyboard
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //forces resign first responder and hides keyboard
        DismissKeyboard()
    }
    
    //7 Add to hide keyboard
    func DismissKeyboard(){
        //forces resign first responder and hides keyboard
        fullname.endEditing(true)
        email.endEditing(true)
        phone.endEditing(true)
        
    }
    //8 Add to hide keyboard
    func textFieldShouldReturn(textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //9 Add logic to load db. If contactdb has content that means a row was tapped on UiTableView
        if (contactdb != nil)
        {
            fullname.text = contactdb.valueForKey("fullname") as String
            email.text = contactdb.valueForKey("email") as String
            phone.text = contactdb.valueForKey("phone") as String
            btnSave.setTitle("Update", forState: UIControlState.Normal)
        }
        fullname.becomeFirstResponder()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

