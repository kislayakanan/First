//
//  ForgotPassVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/3/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class ForgotPassVC: UIViewController
{

    @IBOutlet var passwordFld: UITextField!
    @IBOutlet var emailFld: UITextField!
   // var ref = Firebase(url:"https://shabbatapp.firebaseio.com")
    var ref = FIRDatabase.database().reference()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(ForgotPassVC.backMethod), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "backicon"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "RESET PASSWORD"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 19)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
    }

    func backMethod()
    {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.view.endEditing(true)
    }
    
    //MARK: RESET password action
    @IBAction func resetPasswordAction(sender: AnyObject)
    {
        //To check first internet connection
        emailFld.resignFirstResponder()
        
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            if emailFld.text! == ""
            {
                self.alertShowMethod("", message: "Please enter email id")
            }
            else
            {
                let str = emailFld.text! as NSString
                
                if isValidEmail(str as String)
                {
                    print("it is valid email")
                    
                    FIRAuth.auth()?.sendPasswordResetWithEmail(emailFld.text!) { error in
                        if let error = error {
                            
                            print(error)
                            self.alertShowMethod("", message: "There was an error processing the request try again")
                            
                        } else {
                            print("Password reset sent successfully")
                            self.alertShowMethod("", message: "Password reset sent successfully your email id")
                        }
                    }

                    
//                    ref.resetPasswordForUser(emailFld.text, withCompletionBlock:
//                        { error in
//                            
//                            if error != nil
//                            {
//                                print(error)
//                                self.alertShowMethod("", message: "There was an error processing the request try again")
//                            }
//                            else
//                            {
//                                print("Password reset sent successfully")
//                                self.alertShowMethod("", message: "Password reset sent successfully your email id")
//                                
//                            }
//                    })
                    
                    
                }
                else
                {
                    self.alertShowMethod("", message: "Enter a valid email id")
                }
            }
 
        }
        else
        {
            print("Internet connection Failed")
            self.alertShowMethod("ERROR", message: "Internet connetion failed try again")
            
        }
        
        
    }   
    
    
    @IBAction func signInAction(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        if textField == emailFld
        {
            let str = textField.text! as NSString
            
            if isValidEmail(str as String)
            {
                print("it is valid email")
            }
            else
            {
                self.alertShowMethod("", message: "Enter a valid email id")
            }
            
        }
        
        return true
    }
    
    

    //MARK: to check valid email
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    //MARK: alert method
    func alertShowMethod(Title:String, message:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
