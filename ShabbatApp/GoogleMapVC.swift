//
//  GoogleMapVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/7/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapVC: UIViewController,GMSMapViewDelegate
{

    var user_id: String?
    var mapView = GMSMapView()
    var placeIdArr: AnyObject?
    var menuBtn = 0
    let settingBtn = UIButton(type: .Custom)
    var settingOrCross = "Setting"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor.clearColor()
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(GoogleMapVC.backMethod), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "backicon"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "SEEK"
        nav1Lbl.font = UIFont(name: "Helvetica-Bold", size: 19)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        
        settingBtn.addTarget(self, action:#selector(GoogleMapVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn
        
        
        
        print(placeIdArr?.count)
        
        let camera = GMSCameraPosition.cameraWithLatitude(30.75,
                                                          longitude: 76.78, zoom: 6)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        mapView.myLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
       
        print(placeIdArr)
        
        
        for i in 0 ..< Int((placeIdArr?.count)!)
        {
            self.apiFunction((placeIdArr?.objectAtIndex(i).valueForKey("location"))! as! String, avail_seats: (placeIdArr?.objectAtIndex(i).valueForKey("seats"))! as! String,USR_ID: (placeIdArr?.objectAtIndex(i).valueForKey("user_id"))! as! String)
        }
        
    }

    
    
    func openSetting()
    {
        if settingOrCross == "Setting"
        {
            print("Setting icon is tapped")
            let updateVC = (self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
            updateVC.update = "UPDATE"
            updateVC.user_ID = user_id
            self.navigationController?.pushViewController(updateVC, animated: true)
        }
        else
        {
           self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
           print("Cross icon is tapped" + settingOrCross)
           settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
           settingOrCross = "Setting"
           
        }
        
    }
    
    func addMarkers(Place_ID:String,avail_seats:String,Latitude:CLLocationDegrees,Longtitude:CLLocationDegrees,
                    Title:String,Snippet:String,Plcae_Icon:String ,userId:String)
    {

        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(Latitude, Longtitude)
        marker.title = Title
        marker.snippet = Snippet
        marker.userData = userId
        
        let view = UIView()
        view.frame = CGRect(x: 0,y: 0,width: 40,height: 40)
        view.backgroundColor = UIColor.clearColor()
        
        let placeView = UIImageView()
        placeView.frame = CGRect(x: 5,y: 10,width: 20,height: 20)
        placeView.image = UIImage(named: Plcae_Icon)
        placeView.backgroundColor = UIColor.clearColor()
        
        let statusBtn = UIButton()
        statusBtn.frame = CGRect(x: 5,y: -15,width: 30,height: 30)
        statusBtn.setBackgroundImage(UIImage(named: "orange-circle.png"), forState: .Normal)
        statusBtn.setTitle(avail_seats, forState: .Normal)
        statusBtn.titleLabel?.textColor = UIColor.whiteColor()
        statusBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        
//        let img = UIImageView()
//        img.frame = CGRect(x: 11,y: 10,width: 8,height: 10)
//        img.image = UIImage(named: "header-green-cup.png")
//        statusBtn.addSubview(img)
        
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



 
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker)
    {
        settingOrCross = "Cross"
        
        if (menuBtn==0)
        {
            settingBtn.setImage(UIImage(named: "cross"), forState: .Normal)
            menuBtn += 1
        }
        else
        {
            settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
            menuBtn -= 1
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(marker.userData, forKey: "user_id")

        
        print(marker.userData)
        print(marker.position.latitude)
        print(marker.title)
        
 
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
       
    }
    

    
    //MARK: Method to get lat log using placeId
    func apiFunction(place_ID:String, avail_seats:String,USR_ID:String)
    {
        
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
                            self.addMarkers(place_ID, avail_seats: avail_seats, Latitude: latitude, Longtitude: longtitude, Title: "Chandigarh", Snippet: "Good Place", Plcae_Icon: "place",userId: USR_ID)
                            
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
