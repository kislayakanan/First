//
//  ChatViewController.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/16/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var ref = FIRDatabase.database().reference()
    var chatListTView: UITableView  =   UITableView()
    var user_id:String?
    var USER_CAST:String?
    var AllUserArr: [AnyObject] = [AnyObject]()
    var All_SeekerArr: [AnyObject] = [AnyObject]()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        user_id = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
        USER_CAST =  NSUserDefaults.standardUserDefaults().objectForKey("user_cast") as? String
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "CHAT"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(ChatViewController.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(ChatViewController.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn
        
        
        
        chatListTView.frame =  CGRectMake(0, 70, self.view.frame.width, self.view.frame.height - 70);
        
        chatListTView.separatorColor = UIColor.lightGrayColor()
        chatListTView.backgroundColor = UIColor.clearColor()
        chatListTView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(chatListTView)
        
        /*----------------To check internet connection------------------*/
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
             self.acceptedMembers()
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
        if USER_CAST == "HOST"
        {
            return All_SeekerArr.count;
        }
        else
        {
            return AllUserArr.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        for object in cell.contentView.subviews
        {
            object.removeFromSuperview()
        }
        
        //imageView in cell
        let profilePic = UIImageView()
        profilePic.frame = CGRect(x: 20,y: 10,width: 60,height: 60)
        profilePic.image = UIImage(named: "image")
        profilePic.backgroundColor = UIColor.clearColor()
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = 0.5 * profilePic.bounds.size.width
        cell.contentView.addSubview(profilePic)
        
        
        //Label in cell
        let nameLbl = UILabel(frame: CGRectMake(85, 10, cell.frame.size.width/2, 40))
        
        //Get the name from database
 
        
        

        
        nameLbl.backgroundColor = UIColor.clearColor()
        nameLbl.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(nameLbl)
        
        //imageView in cell
        let msg = UIImageView()
        msg.frame = CGRect(x: cell.frame.size.width/2 + 90,y: 20,width: 40,height: 40)
        msg.image = UIImage(named: "email")
        msg.backgroundColor = UIColor.clearColor()
        msg.clipsToBounds = true
        msg.layer.cornerRadius = 0.5 * msg.bounds.size.width
        cell.contentView.addSubview(msg)
        cell.backgroundColor = UIColor.clearColor()
        
        
        if USER_CAST == "HOST"
        {
            let users = ref.child("USERS")
            let seekerID = users.child((All_SeekerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seeker_id") as! String)
            let user_name = seekerID.child("fullname")
            
            //let user_name = Firebase(url:"https://shabbatapp.firebaseio.com/USERS/" + ((All_SeekerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seeker_id") as! String) + "/fullname")
            
            user_name.observeEventType(.Value, withBlock:
            {
                    snapshot in
                    nameLbl.text = snapshot.value as? String
                    
                    
            })
            
            

            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            myActivityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75)
            myActivityIndicator.center = self.view.center
            myActivityIndicator.startAnimating()
            self.view.addSubview(myActivityIndicator)
            
            
            let images = ref.child("IMAGES")
            let seeker_ID = images.child((All_SeekerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seeker_id") as! String)
            
            let image = seeker_ID.child("fullname")
            
            //let image = Firebase(url:"https://shabbatapp.firebaseio.com/IMAGES/" + ((All_SeekerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seeker_id") as! String) + "/profile_pic")
            image.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    
                    let img = snapshot.value as? NSString
                    if img != nil
                    {
                        let base64EncodedString = img
                        let imageData = NSData(base64EncodedString: base64EncodedString as! String,
                            options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        let decodedImage = UIImage(data:imageData!)
                        profilePic.image = decodedImage!
                       myActivityIndicator.stopAnimating()
                    }
                    else
                    {
                        myActivityIndicator.stopAnimating()
                    }
            })
        }
        else
        {
            let users = ref.child("USERS")
            let seekerID = users.child((AllUserArr as AnyObject).objectAtIndex(indexPath.row) as! String)
            let user_name = seekerID.child("fullname")
            
            //let user_name = Firebase(url:"https://shabbatapp.firebaseio.com/USERS/" + ((AllUserArr as AnyObject).objectAtIndex(indexPath.row) as! String) + "/fullname")
            user_name.observeEventType(.Value, withBlock:
            {
                    snapshot in
                    nameLbl.text = snapshot.value as? String
                    
                    
            })
        }
        return cell;
    }
    
    
    //MARK: Delegates of table view
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        /*----------------To check internet connection------------------*/
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            let chat = (self.storyboard!.instantiateViewControllerWithIdentifier("ChatVC")) as! ChatVC
            chat.senderId = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
            chat.senderDisplayName = ""
            
            if USER_CAST == "HOST"
            {
               chat.connectedPersonId = (All_SeekerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seeker_id") as? String
                chat.requestStatus = (All_SeekerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("status") as? String
                chat.requestedDinnerId = (All_SeekerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("dinner_id") as? String
            }
            else
            {
               chat.connectedPersonId = (AllUserArr as AnyObject).objectAtIndex(indexPath.row) as? String
            }
            
            //print((AllUserArr as AnyObject).objectAtIndex(indexPath.row) as? String)
   /*Error*///chat.connectedPersonId = (AllUserArr as AnyObject).objectAtIndex(indexPath.row) as? String
            self.navigationController?.pushViewController(chat, animated: true)
        }
        else
        {
            self.alertShowMethod("Internet connection error", message: "Please try again")
        }
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
    
    
    func acceptedMembers()
    {
        
        let user_cast = NSUserDefaults.standardUserDefaults().objectForKey("user_cast") as? String
        
        // let request = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
        
        let requests = ref.child("REQUESTS")
        if user_cast == "HOST"
        {
           
            requests.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    let dict = snapshot.value as? NSDictionary
                    
                    
                    
                    if dict!.objectForKey(self.user_id!) != nil
                    {
                        
                        let all_Dinner:NSArray =  dict!.objectForKey(self.user_id!)!.allKeys
                        
                        for i in 0 ..< Int(all_Dinner.count)
                        {
                            
                            let all_user:NSArray =  dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.allKeys
                            
                            for j in 0 ..< Int(all_user.count)
                            {
                                if dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey(all_user.objectAtIndex(j)) as? String == "Request accepted" || dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey(all_user.objectAtIndex(j)) as? String == "You are invited"
                                {
                                    
                                    
                                    let seek_id = all_user.objectAtIndex(j) as? String
                                    let dinner_id = all_Dinner.objectAtIndex(j) as? String
                                    let status = dict!.objectForKey(self.user_id!)!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey(all_user.objectAtIndex(j)) as? String
                                    
                                    let data:NSDictionary = NSDictionary(objects:[seek_id!,dinner_id!,status!], forKeys:["seeker_id","dinner_id","status"])
                                    
                                    self.All_SeekerArr.append(data)
                                    
                                    
                                    if self.AllUserArr.count > 0
                                    {
                                        var duplicate = 1 // for remove duplicacy of users
                                        
                                        for m in 0 ..< Int(self.AllUserArr.count)
                                        {
                                            var arr: AnyObject?
                                            arr = self.AllUserArr

                                            
                                            if arr!.objectAtIndex(m) as? String == all_user.objectAtIndex(j) as? String
                                            {
                                                duplicate = 0
                                                break
                                            }
                                        }
                                        
                                        if duplicate == 0
                                        {
                                            
                                        }
                                        else
                                        {
                                           self.AllUserArr.append(all_user.objectAtIndex(j))
                                        }
                                        
                                    }
                                    
                                    else
                                    {
                                       self.AllUserArr.append(all_user.objectAtIndex(j))
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    
                    print(self.AllUserArr)
                    
                    /* List of all seeker whose are invited or accepted request by host*/
                    print(self.All_SeekerArr)
                    
                    if self.All_SeekerArr.count > 0
                    {
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                self.chatListTView.delegate = self
                                self.chatListTView.dataSource = self
                                self.chatListTView.reloadData()
                        })
                    }
                    else
                    {
                        print("you have no request")
                        self.alertShowMethod("", message: "Nobody for chat")
                    }
                    
            })

        }
        
        
        else
        {
            
            requests.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    let dict = snapshot.value as? NSDictionary
                    print(dict)
                    
                     let all_host:NSArray =  dict!.allKeys
                     if all_host.count > 0
                     {
                        
                        for k in 0 ..< Int(all_host.count)
                        {
                            var flag = 1
                            
                            let all_Dinner:NSArray =  dict!.objectForKey(all_host.objectAtIndex(k))!.allKeys
                            
                            for i in 0 ..< Int(all_Dinner.count)
                            {
                                
                                let all_user:NSArray =  dict!.objectForKey(all_host.objectAtIndex(k))!.objectForKey(all_Dinner.objectAtIndex(i))!.allKeys
                                
                                for j in 0 ..< Int(all_user.count)
                                {
                                    if all_user.objectAtIndex(j) as? String == self.user_id && dict!.objectForKey(all_host.objectAtIndex(k))!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey(all_user.objectAtIndex(j)) as? String == "Request accepted"
                                    {
                                        print("Request accepted")
                                        self.AllUserArr.append(all_host.objectAtIndex(k))
                                        flag = 0
                                        break
                                    }
                      
                                }
                                
                                if flag == 0
                                {
                                    break
                                }
                                
                            }
                        }

                        
                        
                        print(self.AllUserArr)
                        
                     }
                    
                    
                    if self.AllUserArr.count > 0
                    {
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                self.chatListTView.delegate = self
                                self.chatListTView.dataSource = self
                                self.chatListTView.reloadData()
                        })
                    }
                    else
                    {
                        print("you have no request")
                        self.alertShowMethod("", message: "No person is available for HOST")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
