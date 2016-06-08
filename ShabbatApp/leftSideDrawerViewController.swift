//
//  leftSideDrawerViewController.swift
//  Shabbat_Project
//
//  Created by webastral on 5/7/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class leftSideDrawerViewController: UIViewController,UITableViewDataSource, UITableViewDelegate
{

    
    //var ref = Firebase(url:"https://shabbatapp.firebaseio.com")
    var ref = FIRDatabase.database().reference()
    @IBOutlet weak var ImageView: UIImageView!
    var menuItems:[String] = ["John Mike","Dinner Listing","Search Criteria","Chat","Logout"];
    var arrImageName: [String] = ["user-icon","dinner-request-icon","search-icon","matches-icon","logout"]
    
    var menuItems1:[String] = ["John Mike","Create Dinner","Dinner Listing","Invitation","Chat","Logout"];
    var arrImageName1: [String] = ["user-icon","dinner-request-icon","dinner-request-icon","matches-icon","matches-icon","logout"]
    
    
    
    
    
    @IBOutlet weak var drawerTableView: UITableView!


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)
    {
         self.navigationController?.navigationBarHidden = true
         drawerTableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if hostOrSeek == "HOST"
        {
           return menuItems1.count;
        }
        else
        {
           return menuItems.count;
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        let cell = drawerTableView.dequeueReusableCellWithIdentifier("leftDrawerTableViewCell", forIndexPath: indexPath) as! leftDrawerTableViewCell
        

        if hostOrSeek == "HOST"
        {
            cell.cellImageView?.image = UIImage(named:self.arrImageName1[indexPath.row])
            
            cell.cellLabel.text = menuItems1[indexPath.row]
        }
        else
        {
            cell.cellImageView?.image = UIImage(named:self.arrImageName[indexPath.row])
            cell.cellLabel.text = menuItems[indexPath.row]
        }

        cell.cellLabel.font = UIFont(name: "Montserrat-Regular", size: 19)
        return cell;
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        /*----------------Check internet connection--------------*/
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            let selectedCell:UITableViewCell = drawerTableView.cellForRowAtIndexPath(indexPath)!
            selectedCell.contentView.backgroundColor = UIColor.blackColor()
            
            if hostOrSeek == "HOST"
            {
                switch(indexPath.row)
                {
                case 0:print("user clicked")
                
                let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC
                
                let logInNavController = UINavigationController(rootViewController: profileVC)
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.centerContainer!.centerViewController = logInNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                
                
                break;
                    
                case 1:print("create dinnner")
                
                let hostVC = self.storyboard?.instantiateViewControllerWithIdentifier("HostVC") as! HostVC
                
                let logInNavController = UINavigationController(rootViewController: hostVC)
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.centerContainer!.centerViewController = logInNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                
                
                break;
                    
                case 2:
                    print("dinner listing clicked")
                    let hostDinnerListVC = self.storyboard?.instantiateViewControllerWithIdentifier("HostDinnerListVC") as! HostDinnerListVC
                    
                    let logInNavController = UINavigationController(rootViewController: hostDinnerListVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    
                    break;
                    
                case 3:
                    print("Invitation")
                    
                    let invitationVC = self.storyboard?.instantiateViewControllerWithIdentifier("InvitationVC") as! InvitationVC
                    
                    let logInNavController = UINavigationController(rootViewController: invitationVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    
                    break;
                    
                case 4:
                    print("Chat clicked")
                    
                    let chatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
                    let logInNavController = UINavigationController(rootViewController: chatVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    
                    
                    
                    break;
                    
                case 5:
                    
                    print("logout clicked")
                    try! FIRAuth.auth()!.signOut()
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "email")
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "password")
                    
                    let LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenVC") as! MainScreenVC
                    
                    let logInNavController = UINavigationController(rootViewController: LoginVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    break;
                    
                default:
                    
                    print("\(menuItems[indexPath.row]) is selected");
                }
                
            }
            else
            {
                switch(indexPath.row)
                {
                    
                    
                    
                case 0:print("user clicked")
                
                let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC
                
                let logInNavController = UINavigationController(rootViewController: profileVC)
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.centerContainer!.centerViewController = logInNavController
                appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                
                
                break;
                    
                case 1:
                    print("dinner listing")
                    let seekDinnnerListVC = self.storyboard?.instantiateViewControllerWithIdentifier("SeekDinnnerListVC") as! SeekDinnnerListVC
                    
                    let logInNavController = UINavigationController(rootViewController: seekDinnnerListVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    
                    break;
                    
                case 2:
                    
                    print("search clicked")
                    
                    let searchVC = self.storyboard?.instantiateViewControllerWithIdentifier("SearchVC") as! SearchVC
                    
                    let logInNavController = UINavigationController(rootViewController: searchVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    
                    
                    break;
                    
                    
                case 3:
                    print("Chat")
                    
                    let chatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
                    //chatVC.senderId = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
                    // chatVC.senderDisplayName = ""
                    
                    let logInNavController = UINavigationController(rootViewController: chatVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    
                    break;
                    
                case 4:
                    
                    print("logout clicked")
                    try! FIRAuth.auth()!.signOut()
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "email")
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "password")
                    
                    let LoginVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenVC") as! MainScreenVC
                    
                    let logInNavController = UINavigationController(rootViewController: LoginVC)
                    
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.centerContainer!.centerViewController = logInNavController
                    appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                    
                    
                    break;
                    
                default:
                    
                    print("\(menuItems[indexPath.row]) is selected");
                    
                }
                
            }

        }
            
        /*------------- Internet connection error------------*/
        else
        {
            self.alertShowMethod("Internet connection error", message: "Please try again")
        }
        
    }
    
    
    
    //MARK: alert method
    func alertShowMethod(Title:String, message:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
}
    


