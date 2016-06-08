//
//  HostDinnerListVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/12/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit


class HostDinnerListVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var ref = FIRDatabase.database().reference()
    @IBOutlet var tabImageV: UIImageView!
    var dinnerTView: UITableView  =   UITableView()
    var user_Id:String?
    var currentDinnerArr: [AnyObject] = [AnyObject]()
    var archivedDinnerArr: [AnyObject] = [AnyObject]()    
    var selectedTab = "CURRENT"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(NSUserDefaults.standardUserDefaults().objectForKey("current_userID"))
        user_Id = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
        
        
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "DINNER LISTING"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(HostDinnerListVC.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(HostDinnerListVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn

        dinnerTView.frame =  CGRectMake(tabImageV.frame.origin.x, tabImageV.frame.height + tabImageV.frame.origin.y, tabImageV.frame.width, self.view.frame.height-tabImageV.frame.height - tabImageV.frame.origin.y);
        dinnerTView.separatorStyle = .None
        dinnerTView.backgroundColor = UIColor.clearColor()
        dinnerTView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(dinnerTView)
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        /*----------------To check internet connection------------------*/
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            self.findCurrentDinner()
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
        if selectedTab == "CURRENT"
        {
           return currentDinnerArr.count
        }
        else
        {
           return archivedDinnerArr.count
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
        let dateIcon = UIImageView()
        dateIcon.frame = CGRect(x: 0,y: 20,width: 20,height: 20)
        dateIcon.image = UIImage(named: "calender-icon")
        cell.contentView.addSubview(dateIcon)
        
        //Label in cell
        let dateLbl = UILabel(frame: CGRectMake(24, 20, cell.frame.size.width/2 - 24, 20))
        
        if selectedTab == "CURRENT"
        {
          dateLbl.text = (currentDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("date") as? String
        }
        else
        {
          dateLbl.text = (archivedDinnerArr  as AnyObject).objectAtIndex(indexPath.row).objectForKey("date") as? String
        }

        dateLbl.backgroundColor = UIColor.clearColor()
        dateLbl.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(dateLbl)
        
        //imageView in cell
        let timeIcon = UIImageView()
        timeIcon.frame = CGRect(x: cell.frame.size.width/2,y: 20,width: 20,height: 20)
        timeIcon.image = UIImage(named: "clock-icon")
        cell.contentView.addSubview(timeIcon)
        
        //Label in cell
        let timeLbl = UILabel(frame: CGRectMake(cell.frame.size.width/2 + 24, 20, cell.frame.size.width/2-24, 20))
        
        if selectedTab == "CURRENT"
        {
            timeLbl.text = (currentDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("time") as? String
        }
        else
        {
            timeLbl.text = (archivedDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("time") as? String
        }
        
        timeLbl.backgroundColor = UIColor.clearColor()
        timeLbl.textColor = UIColor.orangeColor()
        cell.contentView.addSubview(timeLbl)
        
        //imageView in cell
        let tagIcon = UIImageView()
        tagIcon.frame = CGRect(x: 0,y: 50,width: 20,height: 20)
        tagIcon.image = UIImage(named: "tag-icon")
        cell.contentView.addSubview(tagIcon)
        
        //Label in cell
        let tagLbl = UILabel(frame: CGRectMake(24, 50, cell.frame.size.width - 24, 20))
        
        if selectedTab == "CURRENT"
        {
            tagLbl.text = (currentDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("tag_line") as? String
        }
        else
        {
            tagLbl.text = (archivedDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("tag_line") as? String
        }
        
        tagLbl.backgroundColor = UIColor.clearColor()
        tagLbl.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(tagLbl)
        
        //imageView in cell
        let locIcon = UIImageView()
        locIcon.frame = CGRect(x: 0,y: 80,width: 20,height: 20)
        locIcon.image = UIImage(named: "globe-icon")
        cell.contentView.addSubview(locIcon)
        
        //Label in cell
        let locLbl = UILabel(frame: CGRectMake(24, 80, cell.frame.size.width - 24, 20))
        
        if selectedTab == "CURRENT"
        {
           locLbl.text = (currentDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("city") as? String
        }
        else
        {
            locLbl.text = (archivedDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("city") as? String
        }
        
        locLbl.backgroundColor = UIColor.clearColor()
        locLbl.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(locLbl)

        
        //imageView in cell
        let seatIcon = UIImageView()
        seatIcon.frame = CGRect(x: 0,y: 110,width: 20,height: 20)
        seatIcon.image = UIImage(named: "orange-chair")
        cell.contentView.addSubview(seatIcon)
        
        //Label in cell
        let seatLbl = UILabel(frame: CGRectMake(24, 110, 20, 20))
        
        if selectedTab == "CURRENT"
        {
            seatLbl.text = (currentDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seats") as? String
        }
        else
        {
            seatLbl.text = (archivedDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("seats") as? String
        }
        
        seatLbl.backgroundColor = UIColor.clearColor()
        seatLbl.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(seatLbl)
        
        
        if selectedTab == "CURRENT"
        {
            let remainingSeats = UIImageView()
            remainingSeats.frame = CGRect(x: 48, y: 110, width: 20, height: 20)
            remainingSeats.image = UIImage(named: "grey-chair")
            cell.contentView.addSubview(remainingSeats)
            
            let remainingSeatsLbl = UILabel(frame: CGRectMake(72, 110, 20, 20))
            remainingSeatsLbl.text = "2"
            remainingSeatsLbl.backgroundColor = UIColor.clearColor()
            remainingSeatsLbl.textColor = UIColor.whiteColor()
            cell.contentView.addSubview(remainingSeatsLbl)
            
        }
        
//        else
//        {
//            //Status label
//            let statusLbl = UILabel(frame: CGRectMake(48, 110, cell.frame.size.width/2 - 48, 20))
//            statusLbl.text = "Status"
//            statusLbl.backgroundColor = UIColor.clearColor()
//            statusLbl.textAlignment = NSTextAlignment.Center
//            statusLbl.textColor = UIColor.whiteColor()
//            cell.contentView.addSubview(statusLbl)
//            
//            //Green thumb
//            let greenBtn = UIButton(type: .Custom)
//            greenBtn.addTarget(self, action:#selector(HostDinnerListVC.greenThumbTapped), forControlEvents: .TouchUpInside)
//            greenBtn.setImage(UIImage(named: "green-thumb"), forState: .Normal)
//            greenBtn.frame = CGRectMake(cell.frame.size.width/2, 110, 20, 20)
//            cell.contentView.addSubview(greenBtn)
//            
//            //White thumb
//            let whiteBtn = UIButton(type: .Custom)
//            whiteBtn.addTarget(self, action:#selector(HostDinnerListVC.whiteThumbTapped), forControlEvents: .TouchUpInside)
//            whiteBtn.setImage(UIImage(named: "white-thumb"), forState: .Normal)
//            whiteBtn.frame = CGRectMake(cell.frame.size.width/2 + 22, 110, 20, 20)
//            cell.contentView.addSubview(whiteBtn)
//        }
 
        
        if selectedTab == "CURRENT"
        {
            cell.userInteractionEnabled = true
            cell.backgroundColor = UIColor.clearColor()
        }
        else
        {
            cell.userInteractionEnabled = false
            cell.backgroundColor = UIColor.init(white: 0.4, alpha: 0.3)
        }
        
        //Custom seperator line
        let line = UIView(frame: CGRectMake(cell.frame.origin.x, 139, cell.frame.size.width, 1))
        line.backgroundColor = UIColor.grayColor()
        cell.contentView.addSubview(line)
        
        
  
        return cell
    }
    
    
    func whiteThumbTapped()
    {
        print("white Thumb Tapped")
    }
    
    func greenThumbTapped()
    {
        print("Green Thumb Tapped")
    }
    
    //MARK: Delegates of table view
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 140;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
               
        let updateDinnerVC = (self.storyboard!.instantiateViewControllerWithIdentifier("HostVC")) as! HostVC
        updateDinnerVC.updateDinner = "UPDATE_DINNER"
        updateDinnerVC.dinnerID = (currentDinnerArr as AnyObject).objectAtIndex(indexPath.row).objectForKey("dinner_id") as? String
        self.navigationController?.pushViewController(updateDinnerVC, animated: true)
        
        
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
    
    @IBAction func currentTabMethod(sender: UIButton)
    {
        print("current tab is clicked")
        tabImageV.image = UIImage(named: "current-tab")
        selectedTab = "CURRENT"
        dinnerTView.reloadData()
    }
    
    @IBAction func archivedTabMethod(sender: UIButton)
    {
        print("archived tab is clicked")
        tabImageV.image = UIImage(named: "archived-tab")
        selectedTab = "ARCHIVED"
        dinnerTView.reloadData()
        
    }
    
    //MARK: Method to show current or archived dinner
    func findCurrentDinner()
    {
        let host = ref.child("HOST")
        let hostUser = host.child(user_Id!)
       // let hostUser = Firebase(url:"https://shabbatapp.firebaseio.com/HOST/" + user_Id!)
        hostUser.observeEventType(.Value, withBlock:
            {
                snapshot in
                
          
                let dict = snapshot.value as? NSDictionary
                
                
                
                
                if dict != nil
                {
                    //Device Date for comparison
                    let date = NSDate()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let strDate = dateFormatter.stringFromDate(date)
                    let date7 = dateFormatter.dateFromString(strDate)
                    
                    let all_Dinner:NSArray =  dict!.allKeys
                    
                    for i in 0 ..< Int(all_Dinner.count)
                    {
                        print(all_Dinner.objectAtIndex(i))
                        let dateStr = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("date") as? String
                        print(dateStr)
                        
                        let date8 = dateFormatter.dateFromString(dateStr!)
                        print(date8)
                        
                        if date7!.compare(date8!) == NSComparisonResult.OrderedDescending
                        {
                            NSLog("date1 after date2");
                            let city1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("location") as? String
                            let date3 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("date") as? String
                            let time1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("time") as? String
                            let tag_line1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("tagline") as? String
                            let seats1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("seats") as? String
                            let dinnerId = all_Dinner.objectAtIndex(i) as? String
                            let data:NSDictionary = NSDictionary(objects:[dinnerId!,date3! , time1!,tag_line1! ,city1!,seats1!], forKeys:["dinner_id","date" , "time" , "tag_line" ,"city","seats"])
                            
                            self.archivedDinnerArr.append(data)
                            
                        }
                        else if date7!.compare(date8!) == NSComparisonResult.OrderedAscending
                        {
                            NSLog("date1 before date2");
                            
                            
                            let city1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("location") as? String
                            let date3 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("date") as? String
                            let time1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("time") as? String
                            let tag_line1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("tagline") as? String
                            let seats1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("seats") as? String
                            let dinnerId = all_Dinner.objectAtIndex(i) as? String
                            let data:NSDictionary = NSDictionary(objects:[dinnerId!,date3! , time1!,tag_line1! ,city1!,seats1!], forKeys:["dinner_id","date" , "time" , "tag_line" ,"city","seats"])
                            
                            self.currentDinnerArr.append(data)
                            
                            
                        }
                        else
                        {
                            let time = NSDate()
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            let strTime = dateFormatter.stringFromDate(time)
                            let str = strTime.componentsSeparatedByString(":")
                            
                            let time2 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("time") as? String
                            let str1 = time2!.componentsSeparatedByString(":")
                            
                            
                            if Int(str[0]) > Int(str1[0]) || Int(str[0]) == Int(str1[0]) && Int(str[1]) > Int(str1[1])
                            {
                                print("Archived Dinner")
                                
                                let city1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("location") as? String
                                let date3 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("date") as? String
                                let time1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("time") as? String
                                let tag_line1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("tagline") as? String
                                let seats1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("seats") as? String
                                let dinnerId = all_Dinner.objectAtIndex(i) as? String
                                let data:NSDictionary = NSDictionary(objects:[dinnerId!,date3! , time1!,tag_line1! ,city1!,seats1!], forKeys:["dinner_id","date" , "time" , "tag_line" ,"city","seats"])
                                
                                self.archivedDinnerArr.append(data)
                                
                                
                            }
                            else
                            {
                                print("Current Dinner")
                                
                                let city1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("location") as? String
                                let date3 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("date") as? String
                                let time1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("time") as? String
                                let tag_line1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("tagline") as? String
                                let seats1 = dict!.objectForKey(all_Dinner.objectAtIndex(i))!.objectForKey("seats") as? String
                                let dinnerId = all_Dinner.objectAtIndex(i) as? String
                                let data:NSDictionary = NSDictionary(objects:[dinnerId!,date3! , time1!,tag_line1! ,city1!,seats1!], forKeys:["dinner_id","date" , "time" , "tag_line" ,"city","seats"])
                                
                                self.currentDinnerArr.append(data)
                            }
                            
                        }
                        
                    }
                    
                    self.dinnerTView.delegate   = self
                    self.dinnerTView.dataSource = self
                    self.dinnerTView.reloadData()
 
                }
                
            })

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
