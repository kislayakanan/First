//
//  SeekVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/7/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit
import GoogleMaps

class SeekVC: UIViewController,GMSMapViewDelegate
{

    var user_id: String?
    var mapView = GMSMapView()
    var placeIdArr: AnyObject?
    var menuBtn = 0
    let settingBtn = UIButton(type: .Custom)
    let button = UIButton(type: .Custom)
    var locationArr: [AnyObject] = [AnyObject]()
    var ref = FIRDatabase.database().reference()
    //var host = Firebase(url:"https://shabbatapp.firebaseio.com/HOST")
    var dict:NSDictionary?
    
    //Variables for search criteria
    var search:String?
    var date:String?
    var seats:String?
    var place:String?
    var age:String?
    var kosher:Bool?
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        
        user_id = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
        
        button.addTarget(self, action:#selector(SeekVC.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "SEEK"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        
        settingBtn.addTarget(self, action:#selector(SeekVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn
        
        let camera = GMSCameraPosition.cameraWithLatitude(30.75,
                                                          longitude: 76.78, zoom: 10)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        mapView.myLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
        
        
        
    }
    
    
    //MARK: setting method
    func openSetting()
    {
        if menuBtn == 0
        {
            print("Setting icon is tapped")
            let updateVC = (self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
            updateVC.update = "UPDATE"
            updateVC.user_ID = user_id
            self.navigationController?.pushViewController(updateVC, animated: true)
        }
        else if menuBtn == 1
        {
           self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
           settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
           menuBtn = 0
           
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        /*-------------- To check internet conection ----------------*/
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
        self.findAllShabbatDinnerPlaces()
        }
        else
        {
            self.alertShowMethod("Internet connection error", message: "Please try again")
        }
    }
    
    
    
    
    //MARK: method to add all markers on google map
    func addMarkers(Place_ID:String,avail_seats:String,Latitude:CLLocationDegrees,Longtitude:CLLocationDegrees,
                    Title:String,Snippet:String,Plcae_Icon:String ,userId:String,DinnerId:String)
    {

        print(userId)
        print(user_id)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(Latitude, Longtitude)
        marker.title = Title
        marker.snippet = Snippet
        marker.userData = ["user_id":userId,"dinner_id":DinnerId, "current_user_id":user_id! ]
        
        let view = UIView()
        view.frame = CGRect(x: 0,y: 0,width: 40,height: 40)
        view.backgroundColor = UIColor.clearColor()
        
        let placeView = UIImageView()
        placeView.frame = CGRect(x: 5,y: 10,width: 20,height: 20)
        placeView.image = UIImage(named: Plcae_Icon)
        placeView.backgroundColor = UIColor.clearColor()
        
        let statusBtn = UIButton()
        statusBtn.frame = CGRect(x: 5,y: -15,width: 30,height: 30)
        statusBtn.setTitle(avail_seats, forState: .Normal)
        statusBtn.setBackgroundImage(UIImage(named: "orange-circle.png"), forState: .Normal)        
        
        let requests = ref.child("REQUESTS")
        //let requests = Firebase(url:"https://shabbatapp.firebaseio.com/REQUESTS")
        requests.observeEventType(.Value, withBlock:
            {
                snapshot in
                let dict = snapshot.value as? NSDictionary
                print(dict)
                
                //Chect response is nil or not
                if dict != nil
                {
                    if dict!.objectForKey(userId) != nil
                    {
                        if  dict!.objectForKey(userId)!.objectForKey(DinnerId) != nil
                        {
                            
                            if dict!.objectForKey(userId)!.objectForKey(DinnerId)!.objectForKey(self.user_id) != nil
                            {
                                
                                if dict!.objectForKey(userId)!.objectForKey(DinnerId)!.objectForKey(self.user_id) as? String == "Request has been sent"
                                {
                                    print("Request has been sent")
                                    
                                    
                                    let img = UIImageView()
                                    img.frame = CGRect(x: 11,y: 10,width: 8,height: 10)
                                    img.image = UIImage(named: "grey-cup")
                                    statusBtn.addSubview(img)
                                    statusBtn.setTitle("", forState: .Normal)
                                    
                                    
                                }
                                else if dict!.objectForKey(userId)!.objectForKey(DinnerId)!.objectForKey(self.user_id) as? String == "Request accepted"
                                {
                                    print("Request accepted")
                                    let img = UIImageView()
                                    img.frame = CGRect(x: 11,y: 10,width: 8,height: 10)
                                    img.image = UIImage(named: "green-cup")
                                    statusBtn.addSubview(img)
                                    statusBtn.setTitle("", forState: .Normal)
                                }
                                    
                                else if dict!.objectForKey(userId)!.objectForKey(DinnerId)!.objectForKey(self.user_id) as? String == "You are invited"
                                {
                                    print("Request accepted")
                                    let img = UIImageView()
                                    img.frame = CGRect(x: 11,y: 10,width: 8,height: 10)
                                    img.image = UIImage(named: "ccup")
                                    statusBtn.addSubview(img)
                                    statusBtn.setTitle("", forState: .Normal)
                                }
                                
                                
                            }
                            else
                            {
                                statusBtn.setTitle(avail_seats, forState: .Normal)
                            }
                        }
                        else
                        {
                            statusBtn.setTitle(avail_seats, forState: .Normal)
                        }
                    }
                    else
                    {
                        statusBtn.setTitle(avail_seats, forState: .Normal)
                    }
                    
                }
                
                else
                {
                    print("No result found")
                }
            })
        
        
        statusBtn.titleLabel?.textColor = UIColor.whiteColor()
        statusBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        
        placeView.addSubview(statusBtn)
        view.addSubview(placeView)
        marker.iconView = view
        marker.tracksViewChanges = true
        marker.map = mapView
        
        
    }
    
    
    func backMethod()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
 
    //MARK: method to tap marker marker info window
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker)
    {
                
        if (menuBtn == 0)
        {
            settingBtn.setImage(UIImage(named: "cross"), forState: .Normal)
            menuBtn = 1
            self.findAllShabbatDinnerPlaces()
        
        }
        else
        {
            settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
            menuBtn = 0
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(marker.userData, forKey: "USER_INFO")

        
        print(marker.userData)
        print(marker.position.latitude)
        print(marker.title)
        
 
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
       
    }
    

    
    //MARK: Method to get lat log using placeId
    func apiFunction(place_ID:String, avail_seats:String,USR_ID:String,dinner_id:String)
    {
        print(dinner_id)
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + place_ID + "&key=%20AIzaSyAqRxlbGhWi8TgHda6K23JRcTJciPmkBBc")
        let request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            
            do {
                
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                {
                    
                    let latitude = jsonResult["result"]?.objectForKey("geometry")?.objectForKey("location")?.objectForKey("lat") as! CLLocationDegrees
                    
                    
                    let longtitude = jsonResult["result"]?.objectForKey("geometry")?.objectForKey("location")?.objectForKey("lng") as! CLLocationDegrees
                    
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            print("hello")
                            self.addMarkers(place_ID, avail_seats: avail_seats, Latitude: latitude, Longtitude: longtitude, Title: "Open Profile", Snippet: "", Plcae_Icon: "place",userId: USR_ID,DinnerId: dinner_id)
                            
                    })
                    
                    
                }
            }
                
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }

    
    //MARK: Open side menu
    func openDrawer()
    {
        hostOrSeek = "SEEK"        
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }

    
   //MARK: method for find all places of shabbat dinner
    func findAllShabbatDinnerPlaces()
    {
        let host = ref.child("HOST")
        host.observeEventType(.Value, withBlock:
            {
                snapshot in
                
                self.dict = snapshot.value as? NSDictionary
                //Check result first it is nil or not
                if self.dict != nil
                {
                    let all_user:NSArray =  self.dict!.allKeys
                    print(all_user)
                    
                    for i in 0 ..< Int(all_user.count)
                    {
                        let dinner: NSArray = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.allKeys)!
                        for j in 0 ..< Int(dinner.count)
                        {
                            
                            // To search criteria
                            if self.search == "SEARCH"
                            {
                                print(self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("date") as! String)
                                print(self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("age") as! String)
                                
                                let date1 = self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("date") as! String
                                let age1 = self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("age") as! String
                                
                                // Now only serch according to date and age search criteria
                                if self.date == date1 || self.age == age1
                                {
                                    let location = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("location_id")) as! String
                                    
                                    let seats = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("seats")) as! String
                                    
                                    let usrID = all_user.objectAtIndex(i) as! String
                                    let dinnerId = dinner.objectAtIndex(j) as! String
                                    
                                    let data:NSDictionary = NSDictionary(objects:[location , seats,usrID ,dinnerId], forKeys:["location" , "seats" , "user_id" ,"dinner_id"])
                                    
                                    self.locationArr.append(data)
                                }
                                
                                
                            }
                                
                                //To login by seeker
                            else
                            {
                                let location = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("location_id")) as! String
                                
                                let seats = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("seats")) as! String
                                
                                let usrID = all_user.objectAtIndex(i) as! String
                                let dinnerId = dinner.objectAtIndex(j) as! String
                                
                                let data:NSDictionary = NSDictionary(objects:[location , seats,usrID ,dinnerId], forKeys:["location" , "seats" , "user_id" ,"dinner_id"])
                                
                                self.locationArr.append(data)
                            }
                            
                            
                        }
                        
                    }
                    
                    print(self.locationArr.count)
                    if self.locationArr.count > 0
                    {
                        self.placeIdArr = self.locationArr
                        print(self.placeIdArr?.objectAtIndex(0))
                        
                        
                        for i in 0 ..< Int((self.placeIdArr?.count)!)
                        {
                            self.apiFunction((self.placeIdArr?.objectAtIndex(i).valueForKey("location"))! as! String, avail_seats: (self.placeIdArr?.objectAtIndex(i).valueForKey("seats"))! as! String,USR_ID: (self.placeIdArr?.objectAtIndex(i).valueForKey("user_id"))! as! String,dinner_id: (self.placeIdArr?.objectAtIndex(i).valueForKey("dinner_id"))! as! String)
                        }
                    }
                    else
                    {
                        self.alertShowMethod("", message: "No shabbat dinner found for your search criteria")
                    }
                    
                }
                else
                {
                    print("NO Result found")
                    self.alertShowMethod("", message: "No shabbat dinner")
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

}
