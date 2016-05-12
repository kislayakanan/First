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
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var ageLbl: UILabel!
    @IBOutlet var cityLbl: UILabel!
    @IBOutlet var tagLbl: UILabel!
    var users = Firebase(url:"https://shabbatapp.firebaseio.com/USERS")
    
    var user_id: String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }


    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRequestMethod(sender: UIButton)
    {
        
        
        if sender.currentImage == UIImage(named:"cup")
        {
            
            print("Request has been sent")
            
            sender.setImage(UIImage(named:"green-trophy"), forState: .Normal)
        }
        else
        {
            print("Request has been cancelled")
             sender.setImage(UIImage(named:"cup"), forState: .Normal)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
    profilePicture.clipsToBounds = true
    profilePicture.layer.cornerRadius = 0.5 * profilePicture.bounds.size.width
        
       let user_ID = NSUserDefaults.standardUserDefaults().objectForKey("user_id")
        
        //Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        myActivityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75)
        myActivityIndicator.center = self.view.center
        myActivityIndicator.startAnimating()
        self.view.addSubview(myActivityIndicator)
        
        
        
        self.users.observeEventType(.Value, withBlock:
            {
                snapshot in
                
                let dict = snapshot.value as? NSDictionary
                print(dict)
                
                print(dict!.objectForKey(user_ID!))
                self.nameLbl.text = dict!.objectForKey(user_ID!)!.objectForKey("fullname") as? String
                self.ageLbl.text = dict!.objectForKey(user_ID!)!.objectForKey("age") as? String
                self.cityLbl.text = dict!.objectForKey(user_ID!)!.objectForKey("location") as? String
                self.tagLbl.text = dict!.objectForKey(user_ID!)!.objectForKey("tagline") as? String
                
                let base64EncodedString = dict?.objectForKey(user_ID!)?.objectForKey("profile_pic")
                let imageData = NSData(base64EncodedString: base64EncodedString as! String,
                    options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                let decodedImage = UIImage(data:imageData!)
                self.profilePicture.image = decodedImage!
                
                myActivityIndicator.stopAnimating()
                
                
        })

        
        
        
        
        
        
        
        
        
        
        
        self.navigationController?.navigationBarHidden = true
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
