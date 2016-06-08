//
//  ProfileVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/14/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController
{

    var ref = FIRDatabase.database().reference()
    var user_Id:String?
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var statusLbl: UILabel!    
    @IBOutlet var cityLbl: UILabel!
    @IBOutlet var ageLbl: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        user_Id = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
        
        
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "PROFILE"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(ProfileVC.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(ProfileVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn
        
        let users = ref.child("USERS")
        let user = users.child(user_Id!)
        //let user = Firebase(url:"https://shabbatapp.firebaseio.com/USERS/" + user_Id!)
        user.observeEventType(.Value, withBlock:
        {
            snapshot in
        
            
            let dict = snapshot.value as? NSDictionary
            if dict != nil
            {
                self.nameLbl.text = dict!.objectForKey("fullname") as? String
                self.ageLbl.text = dict!.objectForKey("age") as? String
                self.cityLbl.text = dict!.objectForKey("location") as? String
                self.statusLbl.text = dict!.objectForKey("status") as? String
            }            
            
        })        
        
        
        //Activity Indicator
        let myActivityIndicator1 = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        myActivityIndicator1.transform = CGAffineTransformMakeScale(0.75, 0.75)
        myActivityIndicator1.center = profilePicture.center
        myActivityIndicator1.startAnimating()
        self.view.addSubview(myActivityIndicator1)
        
        profilePicture.clipsToBounds = true
        profilePicture.layer.cornerRadius = 0.5 * profilePicture.bounds.size.width
        
        let images = ref.child("IMAGES")
        let image = images.child(user_Id!)
        //let image = Firebase(url:"https://shabbatapp.firebaseio.com/IMAGES/" + user_Id!)
        image.observeEventType(.Value, withBlock:
            {
                snapshot in
                
                let dict = snapshot.value as? NSDictionary
                if dict != nil
                {
                    let base64EncodedString = dict!.objectForKey("profile_pic")
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

    }

    
    func openDrawer()
    {
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    func openSetting()
    {
        print("Setting icon is tapped")
        let updateVC = (self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
        updateVC.update = "UPDATE"
        self.navigationController?.pushViewController(updateVC, animated: true)
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
