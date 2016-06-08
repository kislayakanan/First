//
//  LoginViewController.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/2/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate
{

    @IBOutlet var remamberBtn: UIButton!
    @IBOutlet var passFld: UITextField!
    @IBOutlet var emailFld: UITextField!
    var USER: String?
    
    //var ref = Firebase(url:"https://shabbatapp.firebaseio.com")
    var ref = FIRDatabase.database().reference()
    
    //var users = Firebase(url:"https://shabbatapp.firebaseio.com/USERS")
    //var user_cast = Firebase(url:"https://shabbatapp.firebaseio.com/USERCAST")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(USER)
        
        print(NSUserDefaults.standardUserDefaults().objectForKey("email"))
        
        if NSUserDefaults.standardUserDefaults().objectForKey("email") == nil
        {

        }
        else
        {
            emailFld.text = NSUserDefaults.standardUserDefaults().objectForKey("email") as? String
            passFld.text = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String
            remamberBtn.setImage( UIImage(named:"checked.png"), forState: .Normal)
        }
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(LoginViewController.backMethod), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "backicon"), forState: .Normal)
        //    button.tintColor =[UIColor blackColor];
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "LOGIN"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
        
    }
    
    func backMethod()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func signUpBtn(sender: AnyObject)
    {
        let signUp = (self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
        signUp.USER = USER
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    @IBAction func tickFunction(sender: UIButton)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if sender.currentImage == UIImage(named:"unchecked.png")
        {
            sender.setImage(UIImage(named:"checked.png"), forState: .Normal)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(emailFld.text, forKey: "email")
            defaults.setObject(passFld.text, forKey: "password")
            
        }
        else
        {
            sender.setImage( UIImage(named:"unchecked.png"), forState: .Normal)
            defaults.setObject(nil, forKey: "email")
            defaults.setObject(nil, forKey: "password")
        }
    }


    @IBAction func forgotPassFld(sender: AnyObject)
    {
        let forgotVC = (self.storyboard!.instantiateViewControllerWithIdentifier("ForgotPassVC")) as UIViewController      
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    
    //MARK: LOGIN ACTION
    @IBAction func loginAction(sender: AnyObject)
    {
        //Check first internet accessibility
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            if emailFld.text == ""
            {
                self.alertShowMethod("Email", message: "Please enter email id")
                emailFld.resignFirstResponder()
                
            }
            else if passFld.text == ""
            {
                
                self.alertShowMethod("Password", message: "Please enter password")
                passFld.resignFirstResponder()
                
            }
            else if isValidEmail(emailFld.text!)
            {
                print("it is valid email")
                
                FIRAuth.auth()?.signInWithEmail(emailFld.text!, password: passFld.text!) { (user, error) in
                    
                    if error == nil
                    {
                    
                            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                            myActivityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75)
                            myActivityIndicator.center = self.view.center
                            myActivityIndicator.startAnimating()
                            self.view.addSubview(myActivityIndicator)
                            
                            let user_cast = self.ref.child("USERCAST")
                            user_cast.observeEventType(.Value, withBlock:
                                {
                                    snapshot in
                                    
                                    let dict = snapshot.value as? NSDictionary
                                    if dict != nil
                                    {
                                        if dict!.objectForKey(user!.uid) != nil
                                        {
                                            if dict!.objectForKey(user!.uid)!.objectForKey("usercast") as? String == self.USER!
                                            {
                                                
                                                let defaults = NSUserDefaults.standardUserDefaults()
                                                defaults.setObject(user!.uid, forKey: "current_userID")
                                                
                                                print("Login Successfully")
                                                if self.USER == "HOST"
                                                {
                                                    let hostVC = (self.storyboard!.instantiateViewControllerWithIdentifier("HostVC")) as! HostVC
                                                    hostVC.user_id = user!.uid
                                                    let defaults = NSUserDefaults.standardUserDefaults()
                                                    defaults.setObject(user!.uid, forKey: "current_userID")
                                                    defaults.setObject(self.emailFld.text, forKey: "email")
                                                    defaults.setObject(self.passFld.text, forKey: "password")
                                                    defaults.setObject(self.USER, forKey: "user_cast")
                                                    self.navigationController?.pushViewController(hostVC, animated: true)
                                                }
                                                else if self.USER == "SEEKER"
                                                {
                                                    let seek = (self.storyboard!.instantiateViewControllerWithIdentifier("SeekVC")) as! SeekVC
                                                    seek.user_id = user!.uid
                                                    let defaults = NSUserDefaults.standardUserDefaults()
                                                    defaults.setObject(user!.uid, forKey: "current_userID")
                                                    defaults.setObject(self.emailFld.text, forKey: "email")
                                                    defaults.setObject(self.passFld.text, forKey: "password")
                                                    defaults.setObject(self.USER, forKey: "user_cast")
                                                    self.navigationController?.pushViewController(seek, animated: true)
                                                    
                                                }
                                                
                                                myActivityIndicator.stopAnimating()
                                                self.alertShowMethod("", message: "You are logged in successfully")
                                            }
                                            else
                                            {
                                                self.alertShowMethod("Error", message: "You are not " + self.USER!)
                                                myActivityIndicator.stopAnimating()
                                            }
                                            
                                        }
                                    }
                            })                        
                        }
                    
                    else
                    {
                        print(error)
                            // an error occurred while attempting login
                            //if let errorCode = FAuthenticationError(rawValue: error.code)
//                            {
//                                switch (errorCode)
//                                {
//                                case .UserDoesNotExist:
//                                    self.alertShowMethod("Error", message: "Email id doesn't match")
//                                case .InvalidEmail:
//                                    print("Handle invalid email")
//                                    self.alertShowMethod("Error", message: "Please enter valid email id")
//                                    
//                                case .InvalidPassword:
//                                    print("Handle invalid password")
//                                    self.alertShowMethod("Error", message: "Password does not match")
//                                default:
//                                    print("Handle default situation")
//                                }
//                            }
                        
                    }
                }
                
                
               // ref.authUser(emailFld.text!, password: passFld.text!)
//                {
//                    error, authData in
//                    
//                    if (error != nil)
//                    {
//                        // an error occurred while attempting login
//                        if let errorCode = FAuthenticationError(rawValue: error.code)
//                        {
//                            switch (errorCode)
//                            {
//                            case .UserDoesNotExist:
//                                self.alertShowMethod("Error", message: "Email id doesn't match")
//                            case .InvalidEmail:
//                                print("Handle invalid email")
//                                self.alertShowMethod("Error", message: "Please enter valid email id")
//                                
//                            case .InvalidPassword:
//                                print("Handle invalid password")
//                                self.alertShowMethod("Error", message: "Password does not match")
//                            default:
//                                print("Handle default situation")
//                            }
//                        }
//                    }
//                    else
//                    {
//                        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
//                        myActivityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75)
//                        myActivityIndicator.center = self.view.center
//                        myActivityIndicator.startAnimating()
//                        self.view.addSubview(myActivityIndicator)
//                        
//                       let user_cast = ref.child("USERCAST")
//                        user_cast.observeEventType(.Value, withBlock:
//                            {
//                                snapshot in
//                                
//                                let dict = snapshot.value as? NSDictionary
//                                if dict != nil
//                                {
//                                    if dict!.objectForKey(user!.uid) != nil
//                                    {
//                                        if dict!.objectForKey(user!.uid)!.objectForKey("usercast") as? String == self.USER!
//                                        {
//                                            
//                                            let defaults = NSUserDefaults.standardUserDefaults()
//                                            defaults.setObject(user!.uid, forKey: "current_userID")
//                                            
//                                            print("Login Successfully")
//                                            if self.USER == "HOST"
//                                            {
//                                                let hostVC = (self.storyboard!.instantiateViewControllerWithIdentifier("HostVC")) as! HostVC
//                                                hostVC.user_id = user!.uid
//                                                let defaults = NSUserDefaults.standardUserDefaults()
//                                                defaults.setObject(user!.uid, forKey: "current_userID")
//                                                defaults.setObject(self.emailFld.text, forKey: "email")
//                                                defaults.setObject(self.passFld.text, forKey: "password")
//                                                defaults.setObject(self.USER, forKey: "user_cast")
//                                                self.navigationController?.pushViewController(hostVC, animated: true)
//                                            }
//                                            else if self.USER == "SEEKER"
//                                            {
//                                                let seek = (self.storyboard!.instantiateViewControllerWithIdentifier("SeekVC")) as! SeekVC
//                                                seek.user_id = user!.uid
//                                                let defaults = NSUserDefaults.standardUserDefaults()
//                                                defaults.setObject(user!.uid, forKey: "current_userID")
//                                                defaults.setObject(self.emailFld.text, forKey: "email")
//                                                defaults.setObject(self.passFld.text, forKey: "password")
//                                                defaults.setObject(self.USER, forKey: "user_cast")
//                                                self.navigationController?.pushViewController(seek, animated: true)
//                                                
//                                            }
//                                            
//                                            myActivityIndicator.stopAnimating()
//                                            self.alertShowMethod("", message: "You are logged in successfully")
//                                        }
//                                        else
//                                        {
//                                            self.alertShowMethod("Error", message: "You are not " + self.USER!)
//                                            myActivityIndicator.stopAnimating()
//                                        }
//                                        
//                                    }
//                                }
//                            })                        
//                    }
//                }
            }
                
            else
            {
                self.alertShowMethod("", message: "Please enter valid email id")
            }

        }
        else
        {
            print("Internet connection Failed")
            self.alertShowMethod("ERROR", message: "Internet connetion failed try again")
        }
        
        
        
  
}
    
    //MARK: alert method
    func alertShowMethod(Title:String, message:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: to check valid email
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
