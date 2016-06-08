//
//  InvitationVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/12/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class InvitationVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    var ref = FIRDatabase.database().reference()
    @IBOutlet var tabImageV: UIImageView!
    var invitationTVW: UITableView  =   UITableView()
    var user_id:String?
    var currentDinnerArr: [AnyObject] = [AnyObject]()
    var archivedDinnerArr: [AnyObject] = [AnyObject]()
    var currentDinnerArr1: AnyObject?
    var archivedDinnerArr1: AnyObject?
    var selectedTab = "ACCEPTED"
    var all_userArr: [AnyObject] = [AnyObject]()
    var paindingUserArr: [AnyObject] = [AnyObject]()
    var rowNo = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        user_id = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "INVITATIONS"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(InvitationVC.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(InvitationVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn
        
        
        
        invitationTVW.frame =  CGRectMake(tabImageV.frame.origin.x, tabImageV.frame.height + tabImageV.frame.origin.y, tabImageV.frame.width, self.view.frame.height - tabImageV.frame.height - tabImageV.frame.origin.y);
        invitationTVW.separatorStyle = .None
        invitationTVW.backgroundColor = UIColor.clearColor()
        invitationTVW.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(invitationTVW)
        self.invitationTVW.delegate = self
        self.invitationTVW.dataSource = self
        
        /*----------------To check internet connection------------------*/
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            self.acceptedOrPaindingMethod()
        }
        else
        {
            self.alertShowMethod("Internet connection error", message: "Please try again")
        }
        
    }
    
    
    
    //MARK: Datasource methods of table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if selectedTab == "ACCEPTED"
        {
            return all_userArr.count
        }
        else
        {
            return paindingUserArr.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        for object in cell.contentView.subviews
        {
            object.removeFromSuperview()
        }
        
        var seekerID:String!
        
        if selectedTab == "ACCEPTED"
        {
            seekerID = (all_userArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seeker_id") as! String
        }
        else
        {
            seekerID = (paindingUserArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seeker_id") as! String
        }
        
        
        
        //imageView in cell
        let profilePic = UIImageView()
        profilePic.frame = CGRect(x: 0,y: 10,width: 60,height: 60)
        profilePic.image = UIImage(named: "image")
        profilePic.backgroundColor = UIColor.clearColor()
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = 0.5 * profilePic.bounds.size.width
        cell.contentView.addSubview(profilePic)
        
        //let img = Firebase(url:"https://shabbatapp.firebaseio.com/IMAGES")
        let img = ref.child("IMAGES")

        
        dispatch_async(dispatch_get_main_queue(),
        {
            img.observeEventType(.Value, withBlock:
              {
                                snapshot in
                                
                               // print(snapshot.value.count)
                                
                                
                                let dict = snapshot.value as? NSDictionary
                                
                                if dict!.objectForKey(seekerID)?.objectForKey("profile_pic") != nil
                                {
                                    let base64EncodedString = dict!.objectForKey(seekerID)?.objectForKey("profile_pic")
                                    
                                    let imageData = NSData(base64EncodedString: base64EncodedString as! String,
                                        options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                    let decodedImage = UIImage(data:imageData!)
                                    profilePic.image = decodedImage
                                    
                        }
                })
        
        })
        
        
        //Label in cell
        let nameLbl = UILabel(frame: CGRectMake(65, 10, cell.frame.size.width/2, 20))
        //nameLbl.text = "Full Name"
        nameLbl.backgroundColor = UIColor.clearColor()
        nameLbl.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(nameLbl)
        
//        //Label in cell
//        let locLbl = UILabel(frame: CGRectMake(65, 30, cell.frame.size.width/2, 20))
//        locLbl.text = "Date and time"
//        locLbl.backgroundColor = UIColor.clearColor()
//        locLbl.textColor = UIColor.whiteColor()
//        locLbl.font = UIFont.systemFontOfSize(8)
//        cell.contentView.addSubview(locLbl)
        
        //Label in cell
        let statusLbl = UILabel(frame: CGRectMake(65, 50, cell.frame.size.width/2, 20))
        //statusLbl.text = "Status"
        statusLbl.backgroundColor = UIColor.clearColor()
        statusLbl.textColor = UIColor.whiteColor()
        statusLbl.font = UIFont.systemFontOfSize(8)
        cell.contentView.addSubview(statusLbl)
        
        
        
        //let users = Firebase(url:"https://shabbatapp.firebaseio.com/USERS")
        let users = ref.child("USERS")
        users.observeEventType(.Value, withBlock:
        {
                snapshot in
                //print(snapshot.value.count)
                let dict = snapshot.value as? NSDictionary
                nameLbl.text = dict!.objectForKey(seekerID)?.objectForKey("fullname") as? String
                statusLbl.text = dict!.objectForKey(seekerID)?.objectForKey("status") as? String
        
        })
        
        //imageView in cell
        let cupImageV = UIButton()
        cupImageV.addTarget(self, action:#selector(InvitationVC.acceptOrConfirmation(_:)), forControlEvents: .TouchUpInside)
        cupImageV.backgroundColor = UIColor.clearColor()
        cupImageV.tag = 500 + Int(indexPath.row)
        cell.contentView.addSubview(cupImageV)
        
        
        //imageView in cell
        let chatImageV = UIButton()
        chatImageV.frame = CGRect(x: cell.frame.size.width/2 + 105,y: 25,width: 30,height: 30)
        chatImageV.addTarget(self, action:#selector(InvitationVC.chatOrRejectMethod(_:)), forControlEvents: .TouchUpInside)
        chatImageV.tag = 1000 + Int(indexPath.row)
        chatImageV.backgroundColor = UIColor.clearColor()
        cell.contentView.addSubview(chatImageV)
        
        
        
        if selectedTab == "ACCEPTED"
        {
           
           if (all_userArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("text") as! String == "Request accepted"
           {
            cupImageV.setImage(UIImage(named: "green-trophy"), forState: .Normal)

           }
            else if (all_userArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("text") as! String == "Request has been sent"
           {
             cupImageV.setImage(UIImage(named: "cup1"), forState: .Normal)
            }
            else
           {
              cupImageV.setImage(UIImage(named: "yllow_cup"), forState: .Normal)
            }
           
           cupImageV.frame = CGRect(x: cell.frame.size.width/2 + 65,y: 25,width: 20,height: 30)
           chatImageV.setImage(UIImage(named: "chat"), forState: .Normal)
        }
        else
        {
           
            cupImageV.setImage(UIImage(named: "green-tick"), forState: .Normal)
            cupImageV.frame = CGRect(x: cell.frame.size.width/2 + 65,y: 25,width: 30,height: 30)
            chatImageV.setImage(UIImage(named: "cross-red"), forState: .Normal)
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
    func acceptOrConfirmation(sender:UIButton)
    {
        if selectedTab == "ACCEPTED"
        {
            if sender.currentImage == UIImage(named:"green-trophy")
            {
                print("green trophy")
                
                print("Finally u are invited in dinner")
                
                
                let data =
                    [
                        (all_userArr as AnyObject).objectAtIndex(Int(sender.tag) - 500).objectForKey("seeker_id") as! String:"You are invited"
                   ]
                
                //let request = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
                let request = ref.child("REQUESTS")
                let requests = request.child(user_id!)
                let dinner = requests.child((all_userArr as AnyObject).objectAtIndex(Int(sender.tag) - 500).objectForKey("dinner_id") as! String)
                dinner.updateChildValues(data)//to update child values
                self.acceptedOrPaindingMethod()
                self.alertShowMethod("", message: "Finally you are invited")

            }
                
                
            else if sender.currentImage == UIImage(named:"cup1")
            {
                 print("cup1")
                let data =
                    [
                        (all_userArr as AnyObject).objectAtIndex(Int(sender.tag) - 500).objectForKey("seeker_id") as! String:"Request accepted"
                ]
                
                //let request = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
                let request = ref.child("REQUESTS")
                let requests = request.child(user_id!)
                let dinner = requests.child((all_userArr as AnyObject).objectAtIndex(Int(sender.tag) - 500).objectForKey("dinner_id") as! String)
                dinner.updateChildValues(data)//to update child values
                self.acceptedOrPaindingMethod()
                //self.alertShowMethod("", message: "Your request is accepted")

            }
            
        }
        else
        {
            if sender.currentImage == UIImage(named:"green-tick")
            {
                print("green-tick")
                
                let data =
                    [
                        (paindingUserArr as AnyObject).objectAtIndex(Int(sender.tag) - 500).objectForKey("seeker_id") as! String:"Request accepted"
                   
                    ]
                
                //let request = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
                let request = ref.child("REQUESTS")
                let requests = request.child(user_id!)
                let dinner = requests.child((paindingUserArr as AnyObject).objectAtIndex(Int(sender.tag) - 500).objectForKey("dinner_id") as! String)
                dinner.updateChildValues(data)//to update child values
                self.acceptedOrPaindingMethod()

            }

        }

    }
    
    func chatOrRejectMethod(sender:UIButton)
    {
        if selectedTab == "ACCEPTED"
        {
           print("chat")
            
            
            let chat = (self.storyboard!.instantiateViewControllerWithIdentifier("ChatVC")) as! ChatVC
            chat.senderId = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
            chat.senderDisplayName = ""
            chat.connectedPersonId = (all_userArr as AnyObject).objectAtIndex(Int(sender.tag) - 1000).objectForKey("seeker_id") as? String
            
            self.navigationController?.pushViewController(chat, animated: true)

        }
        else
        {
            selectedTab = "PAINDING"
            //let request = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
            let request = ref.child("REQUESTS")
            let requests = request.child(user_id!)
            let dinner = requests.child((paindingUserArr as AnyObject).objectAtIndex(Int(sender.tag) - 1000).objectForKey("dinner_id") as! String)
            let sender1 = dinner.child((paindingUserArr as AnyObject).objectAtIndex(Int(sender.tag) - 1000).objectForKey("seeker_id") as! String)
            sender1.removeValue()//to remove child value
            self.acceptedOrPaindingMethod()
            
            
        }
    }
    
    
    
    //MARK: Delegates of table view
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //print(indexPath.row)
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
    
    
    
    @IBAction func acceptedInvitationAction(sender: UIButton)
    {
        print("Accepted invitations")
        selectedTab = "ACCEPTED"
        self.acceptedOrPaindingMethod()
        tabImageV.image = UIImage(named: "accepted")
        
    }
    
    
    
    @IBAction func paindingInvitationAction(sender: UIButton)
    {
        print("Painding invitations")
        selectedTab = "PAINDING"
        self.acceptedOrPaindingMethod()
        tabImageV.image = UIImage(named: "painding")
        
    }
    
    
    
    func acceptedOrPaindingMethod()
    {
        all_userArr = [AnyObject]()
        paindingUserArr = [AnyObject]()
     
        let request = ref.child("REQUESTS")
        //let request = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
        
        if selectedTab == "ACCEPTED"
        {
            request.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    let dict = snapshot.value as? NSDictionary
                    
                    if dict != nil
                    {
                        if dict!.objectForKey(self.user_id!) != nil
                        {
                            
                            let all_Dinner:NSArray =  dict!.objectForKey(self.user_id!)!.allKeys
                            
                            self.all_userArr.removeAll()
                            
                            for i in 0 ..< Int(all_Dinner.count)
                            {
                                
                                let all_user:NSArray =  dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.allKeys
                                
                                for j in 0 ..< Int(all_user.count)
                                {
                                    
                                    let dinnerId = all_Dinner.objectAtIndex(i) as? String
                                    let seekID = all_user.objectAtIndex(j) as? String
                                    let text = dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey(all_user.objectAtIndex(j)) as? String
                                    let data:NSDictionary = NSDictionary(objects:[dinnerId!,seekID!,text!], forKeys:["dinner_id","seeker_id" , "text"])
                                    self.all_userArr.append(data)
                                    
                                }
                                
                            }
                        }
                                                
                        
                        if self.all_userArr.count > 0
                        {
                            
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                    self.invitationTVW.reloadData()
                            })
                        }
                        else
                        {
                            print("you have no request")
                            self.alertShowMethod("", message: "No person for SEEK")
                        }
                    }                    

            })

        }
            
        else if selectedTab == "PAINDING"
        {
            request.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    let dict = snapshot.value as? NSDictionary
                    
                    if dict != nil
                    {
                        if dict!.objectForKey(self.user_id!) != nil
                        {
                            
                            let all_Dinner:NSArray =  dict!.objectForKey(self.user_id!)!.allKeys
                            
                            self.paindingUserArr.removeAll()
                            
                            for i in 0 ..< Int(all_Dinner.count)
                            {
                                
                                let all_user:NSArray =  dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.allKeys
                                
                                for j in 0 ..< Int(all_user.count)
                                {
                                    
                                    if dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey(all_user.objectAtIndex(j)) as? String == "Request has been sent"
                                    {
                                        let dinnerId = all_Dinner.objectAtIndex(i) as? String
                                        let seekID = all_user.objectAtIndex(j) as? String
                                        let text = dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey(all_user.objectAtIndex(j)) as? String
                                        let data:NSDictionary = NSDictionary(objects:[dinnerId!,seekID!,text!], forKeys:["dinner_id","seeker_id" , "text"])
                                        self.paindingUserArr.append(data)
                                    }
                                }
                                
                            }
                        }
                        
                        
                      
                        
                        if self.paindingUserArr.count > 0
                        {
                            
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                    self.invitationTVW.delegate = self
                                    self.invitationTVW.dataSource = self
                                    self.invitationTVW.reloadData()
                            })
                        }
                        else
                        {
                            print("you have no request")
                            self.alertShowMethod("", message: "You have no request")
                            self.paindingUserArr.removeAll()
                            self.invitationTVW.reloadData()
                        }
                    }
            })

        }
    
}
    
    
    
    
    
    //MARK: alert method
    func alertShowMethod(Title:String, message:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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


//extension UIImage {
//    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->())
//    {
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
//            let newSize:CGSize = size
//            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
//            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//            self.drawInRect(rect)
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            let imageData = UIImageJPEGRepresentation(newImage, 0.1)
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                completionHandler(resizedImage: newImage, data:imageData!)
//            })
//        })
//    }
//}
