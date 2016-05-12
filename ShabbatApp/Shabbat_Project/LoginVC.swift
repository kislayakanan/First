//
//  LoginVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/18/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit


class LoginVC: UIViewController
{
  
    
    //MARK:  method to facebook Login
    @IBAction func loginWithFB(sender: AnyObject)
    {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self)
        {
            (result, error) -> Void in
            if (error == nil)
            {
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
            else
            {
                print(error)
            }
        }
    }
 
    
    //MARK:  get data from fb user
    func getFBUserData()
    {
        if((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                
                if (error == nil)
                {
                    
                    //everything works print the user data
                    print(result)
                    
                    let strFirstName: String = (result.objectForKey("first_name") as? String)!
                    let strLastName: String = (result.objectForKey("last_name") as? String)!
                    let email: String = (result.objectForKey("email") as? String)!
                     let gender: String = (result.objectForKey("gender") as? String)!
                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!                
                    print(strLastName,strFirstName,gender)
                    print(strPictureURL)
                  
                    
                    // query for existing user
                    let query = PFQuery(className: "_User")
                    query.whereKey("email", equalTo: email)
                    query.findObjectsInBackgroundWithBlock
                        {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil
                        {
                            if (objects!.count > 0)
                            {
                                
                                print("You have already registered")
                                let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenVC") as! MainScreenVC
                                self.navigationController?.pushViewController(homeVC, animated: true)
                                
                                
//                                let sign_upVC = self.storyboard?.instantiateViewControllerWithIdentifier("RegistrationVC") as! RegistrationVC
//                                sign_upVC.responseResult=result
//                                
//                                self.navigationController?.pushViewController(sign_upVC, animated: true)
                                
                                
                                
                            }
                            else
                            {
                               print("Username is available.")
                                
                              let sign_upVC = self.storyboard?.instantiateViewControllerWithIdentifier("RegistrationVC") as! RegistrationVC
                                sign_upVC.responseResult=result
                                
                            self.navigationController?.pushViewController(sign_upVC, animated: true)
                                
                            }                            
                        }
                            
                        else
                        {
                            print(error)
                        }
                    }
                    
                }
            })
        }
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor.grayColor()
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "SHABBAT APP"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 19)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        

    }
    
   


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
