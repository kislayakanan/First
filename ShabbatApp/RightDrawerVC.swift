//
//  RightDrawerVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/11/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class RightDrawerVC: UIViewController
{

    var ref = FIRDatabase.database().reference()
    @IBOutlet var requestBtn: UIButton!
    @IBOutlet var requestLbl: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var ageLbl: UILabel!
    @IBOutlet var cityLbl: UILabel!
    @IBOutlet var tagLbl: UILabel!
    //var users = Firebase(url:"https://shabbatapp.firebaseio.com/USERS")
    //var requests = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
    //var images = Firebase(url:"https://shabbatapp.firebaseio.com/IMAGES")
    var user_id: String?
    var current_user_id: String?
    var dinner_id: String?
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK: Method to send or cancel request
    @IBAction func sendRequestMethod(sender: UIButton)
    {
        if sender.currentImage == UIImage(named:"cup")
        {
            //To save request of sent by current user
            let requests = ref.child("REQUESTS")
            let request = requests.child(user_id!)
            //let request = self.requests.child(user_id)
            let dinner = request.child(dinner_id!)
            let sender1 = dinner.child(current_user_id!)
            sender1.setValue("Request has been sent")
            
            print("Request has been sent")
            self.alertShowMethod("", message: "Request has been sent to host")
            requestLbl.text = "Cancel request"
            sender.setImage(UIImage(named:"cup1"), forState: .Normal)
        }
        else
        {
            print("Request has been cancelled")
            //To delete request of sent by current user
            self.alertShowMethod("", message: "Are you sure to cancel the request")
//
//            print(user_id)
//            print(dinner_id)
//            print(current_user_id)
//            
//            
//            //let request = self.requests.child(user_id)
//            let requests = ref.child("REQUESTS")
//            let request = requests.child(user_id!)
//            let dinner = request.child(dinner_id!)
//            let sender1 = dinner.child(current_user_id!)
//            sender1.removeValue()
//            
//            self.alertShowMethod("", message: "Request has been cancelled")
//            requestLbl.text = "Request for dinner"
//            sender.setImage(UIImage(named:"cup"), forState: .Normal)
        }
        
    }
    
    
    //MARK: This method is called first when side menu is opened
    override func viewWillAppear(animated: Bool)
    {
        
        profilePicture.clipsToBounds = true
        profilePicture.layer.cornerRadius = 0.5 * profilePicture.bounds.size.width
        self.requestBtn.userInteractionEnabled = true
        
        let user_ID = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")?.objectForKey("user_id")
        
        user_id = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")?.objectForKey("user_id") as? String
        
        dinner_id = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")?.objectForKey("dinner_id") as? String
        
        current_user_id = (NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")?.objectForKey("current_user_id")) as? String
       
        
        //Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        myActivityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75)
        myActivityIndicator.center = self.view.center
        myActivityIndicator.startAnimating()
        self.view.addSubview(myActivityIndicator)
        
        
        // Fetch data from database of clicked user
        let users = ref.child("USERS")
        
        users.observeEventType(.Value, withBlock:
            {
                snapshot in
                
                let dict = snapshot.value as? NSDictionary
                
                self.nameLbl.text = "Name: " + (dict!.objectForKey(user_ID!)!.objectForKey("fullname") as? String)! as String
                self.ageLbl.text = "Age: " + (dict!.objectForKey(user_ID!)!.objectForKey("age") as? String)! as String
                self.cityLbl.text = "City: " + (dict!.objectForKey(user_ID!)!.objectForKey("location") as? String)! as String
                self.tagLbl.text = "Tag: " + (dict!.objectForKey(user_ID!)!.objectForKey("tagline") as? String)! as String
                
                myActivityIndicator.stopAnimating()
                
                
        })
        
        
        
        
        //Activity Indicator
        let myActivityIndicator1 = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        myActivityIndicator1.transform = CGAffineTransformMakeScale(0.75, 0.75)
        myActivityIndicator1.center = profilePicture.center
        myActivityIndicator1.startAnimating()
        self.view.addSubview(myActivityIndicator1)
        
        
        // Fetch data from database of clicked user
        
        let images = ref.child("IMAGES")
        images.observeEventType(.Value, withBlock:
            {
                snapshot in
                let dict = snapshot.value as? NSDictionary
                print(dict)
                if dict != nil
                {
                    let base64EncodedString = dict?.objectForKey(user_ID!)?.objectForKey("profile_pic")
                    let imageData = NSData(base64EncodedString: base64EncodedString as! String,
                        options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    let decodedImage = UIImage(data:imageData!)
                    self.profilePicture.image = decodedImage!
                    myActivityIndicator1.stopAnimating()
 
                }
                else
                {
                   myActivityIndicator1.stopAnimating()
                }                
                
        })
        
        
        
        
        //for cup color
        let requests = ref.child("REQUESTS")
        
        requests.observeEventType(.Value, withBlock:
            {
                snapshot in
                let dict = snapshot.value as? NSDictionary
                if dict != nil
                {
                    if dict!.objectForKey(user_ID!) != nil
                    {
                        if dict!.objectForKey(user_ID!)!.objectForKey(self.dinner_id) != nil
                        {
                            if dict!.objectForKey(user_ID!)!.objectForKey(self.dinner_id)!.objectForKey(self.current_user_id) != nil
                            {
                                if dict!.objectForKey(user_ID!)!.objectForKey(self.dinner_id)!.objectForKey(self.current_user_id) as? String == "Request has been sent"
                                {
                                    print("Request has been sent")
                                    self.requestBtn.setImage(UIImage(named: "cup1"), forState: .Normal)
                                    self.requestLbl.text = "Cancel request"
                                    self.requestBtn.userInteractionEnabled = true
                                    
                                }
                                else if dict!.objectForKey(user_ID!)!.objectForKey(self.dinner_id)!.objectForKey(self.current_user_id) as? String == "Request accepted"
                                {
                                    print("Request accepted")
                                    self.requestBtn.setImage(UIImage(named: "header-green-cup"), forState: .Normal)
                                    self.requestLbl.text = "Your request accepted"
                                    self.requestBtn.userInteractionEnabled = false
                                    
                                }
                                else if dict!.objectForKey(user_ID!)!.objectForKey(self.dinner_id)!.objectForKey(self.current_user_id) as? String == "You are invited"
                                {
                                    print("You are invited")
                                    self.requestBtn.setImage(UIImage(named: "yllow_cup"), forState: .Normal)
                                    self.requestLbl.text = "You are invited"
                                    self.requestBtn.userInteractionEnabled = false
                                    
                                }
                                
                            }
                            else
                            {
                                self.requestBtn.setImage(UIImage(named: "cup"), forState: .Normal)
                                self.requestLbl.text = "Request for dinner"
                            }
                            
                            
                        }
                        else
                        {
                            self.requestBtn.setImage(UIImage(named: "cup"), forState: .Normal)
                            self.requestLbl.text = "Request for dinner"
                        }
                        
                    }
                    else
                    {
                        self.requestBtn.setImage(UIImage(named: "cup"), forState: .Normal)
                        self.requestLbl.text = "Request for dinner"
                    }

                }
                else
                {
                    self.requestBtn.setImage(UIImage(named: "cup"), forState: .Normal)
                    self.requestLbl.text = "Request for dinner"
                }
        })
        
        self.navigationController?.navigationBarHidden = true
    }

    
    //MARK: alert method
    func alertShowMethod(Title:String, message:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Condition for delete the request
        if message == "Are you sure to cancel the request"
        {
            let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                let requests = self.ref.child("REQUESTS")
                let request = requests.child(self.user_id!)
                let dinner = request.child(self.dinner_id!)
                let sender1 = dinner.child(self.current_user_id!)
                sender1.removeValue()
                
                self.alertShowMethod("", message: "Request has been cancelled")
                self.requestLbl.text = "Request for dinner"
                self.requestBtn.setImage(UIImage(named:"cup"), forState: .Normal)

                
            }
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                //Nothing do
                
                
            }
            alert.addAction(cancelAction)
            
        }
        
        else
        {
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }

        self.presentViewController(alert, animated: true, completion: nil)
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
