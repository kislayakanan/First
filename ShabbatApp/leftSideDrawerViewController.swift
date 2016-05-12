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
    
    var ref = Firebase(url:"https://shabbatapp.firebaseio.com")
    @IBOutlet weak var ImageView: UIImageView!
    var menuItems:[String] = ["","John Mike","Dinner Request","Search Criteria","Matches","Logout"];
    var arrImageName: [String] = ["login-logo","user-icon","dinner-request-icon","search-icon","matches-icon","logout"]
    
    @IBOutlet weak var drawerTableView: UITableView!


    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)
    {
         self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        let cell = drawerTableView.dequeueReusableCellWithIdentifier("leftDrawerTableViewCell", forIndexPath: indexPath) as! leftDrawerTableViewCell
        
//        var imageViewObject :UIImageView
//        imageViewObject = UIImageView(frame:CGRectMake(0, 0, 100, 100));
//        imageViewObject.image = UIImage(named:self.arrImageName[indexPath.row])
//        cell.addSubview(imageViewObject)
        cell.cellImageView?.image = UIImage(named:self.arrImageName[indexPath.row])
       // cell.textLabel!.text = menuItems[indexPath.row]
       // cell.textLabel?.textColor = UIColor.whiteColor()
        cell.cellLabel.text = menuItems[indexPath.row]
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedCell:UITableViewCell = drawerTableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.blackColor()
        
        switch(indexPath.row)
        {
            
        case 0:print("userpic clicked")
            

        
            break;
            
        case 1:print("user clicked")
            

            
            break;
            
        case 2:
            print("dinner request clicked")
            
            break;
            
        case 3:
            
            print("search clicked")
            
            break;
            
        case 4:
            print("maches clicked")
            
            break;
            
        case 5:
            
            print("logout clicked")
            ref.unauth()
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
    


