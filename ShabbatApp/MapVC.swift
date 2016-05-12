//
//  MapVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/20/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate
{

    var placeIdArr: AnyObject? 
    
    var userlocation_lat: CLLocationDegrees!
    var userlocation_lng: CLLocationDegrees!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    
    let locationManager = CLLocationManager()
    
    var latLongArr: [AnyObject] = [AnyObject]()
    
    
    
    @IBOutlet var shabbatMapView: MKMapView!
    
    var readArray : [NSString] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //read data from  UserDefaults
         let shabbat_places_arr : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("placeIdArr")
       
        print(NSUserDefaults.standardUserDefaults().objectForKey("placeIdArr"))
       
        //For show all places on map
        for i in 0 ..< Int((shabbat_places_arr?.count)!)
        {
            
           let placeId = shabbat_places_arr![i].valueForKey("location_id") as! String
           let tag_line = shabbat_places_arr![i].valueForKey("tag_line") as! String
           let avail_seats = shabbat_places_arr![i].valueForKey("avail_seats") as! String
           self.apiFunction(placeId,avail_seats: avail_seats,tag_line: tag_line)
        }
                
        seenError = false
        locationFixAchieved = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()          
        print(self.shabbatMapView.userLocation.coordinate.longitude)
        
   
        
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "PLACES"
        nav1Lbl.font = UIFont(name: "Helvetica-Bold", size: 19)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(MainScreenVC.backMethod), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "back-icon"), forState: .Normal)
        //    button.tintColor =[UIColor blackColor];
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        
    }
    
    
    func backMethod()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }


    
   //MARK:- Delegate methods of location manager
    func locationManager(_manager: CLLocationManager,didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse
        {
            shabbatMapView.showsUserLocation = true
            shabbatMapView.delegate = self
            print(self.shabbatMapView.userLocation.coordinate.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if (locationFixAchieved == false)
        {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            userlocation_lat = coord.latitude
            userlocation_lng = coord.longitude
            self.showCurrentLocationPin()
        }
    }
    
    //MARK:- Method to show current location pin on map
    func showCurrentLocationPin() -> Void
    {
        
        ///Red Pin        
        
        let myHomePin = MKPointAnnotation()
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userlocation_lat, userlocation_lng)
        
//        var region = self.shabbatMapView.region as MKCoordinateRegion
//        region.span.longitudeDelta = 0.02
//        region.span.latitudeDelta = 0.02
//        
//        region.center = myLocation
//        shabbatMapView.setRegion(region, animated: true)
        
        myHomePin.coordinate = myLocation
        myHomePin.title = "Home"
        myHomePin.subtitle = "Bogdan's home"
        self.shabbatMapView.addAnnotation(myHomePin)
    }


    

    
    //MARK: Method to get lat log using placeId
    func apiFunction(place_ID:String, avail_seats:String, tag_line:String)
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
                            self.addAllPins(place_ID,avail_seats: avail_seats,tag_line: tag_line,lat: latitude,lng: longtitude)
                            return
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
   
    
    //MARK: Method to show all pins on map
    func addAllPins(place_ID:String, avail_seats:String, tag_line:String,lat:CLLocationDegrees,lng:CLLocationDegrees) -> Void
    {
        let myHomePin = MKPointAnnotation()
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lng)
        myHomePin.coordinate = myLocation
        myHomePin.title = avail_seats
        myHomePin.subtitle = tag_line
        self.shabbatMapView.addAnnotation(myHomePin)
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

     
     https://maps.googleapis.com/maps/api/geocode/json?address=chandigarh&sensor=false
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
     
     //                    print(lng,lat)
     //
     //                    print(jsonResult["result"]?.objectForKey("geometry")?.objectForKey("location")?.objectForKey("lat"))
     //                    print(jsonResult["result"]?.objectForKey("geometry")?.objectForKey("location")?.objectForKey("lng"))
     //
     //                    let dic1:NSMutableDictionary = [:]
     //                    let dic:NSMutableDictionary = [:]
     //
     //
     //
     //
     //                    dic1.setValue(jsonResult["result"]?.objectForKey("geometry")?.objectForKey("location")?.objectForKey("lat"), forKey: "lat")
     //                    dic1.setValue(jsonResult["result"]?.objectForKey("geometry")?.objectForKey("location")?.objectForKey("lng"), forKey: "lng")
     //
     //                    dic.setValue(dic1, forKey: place_ID)
     //
     //                    self.latLongArr.append(dic)
     //                    print(self.latLongArr)
     
     
    }
    */

}
