//
//  SeekVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/20/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class SeekVC: UIViewController,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate
{
    var user_id: String?
    @IBOutlet var seatFld: UITextField!
    @IBOutlet var kosherFld: UITextField!
    @IBOutlet var DoneBtnView: UIView!
    @IBOutlet var dateTxtFld: UITextField!
    @IBOutlet var ageTxtFld: UITextField!
    @IBOutlet var dateBtn: UIButton!
    @IBOutlet var dateAndTimePicker: UIDatePicker!
    @IBOutlet var locTxtFld: UITextField!
    @IBOutlet var agePicker: UIPickerView!    
    var ageRange = ["18 and under","19 to 23","24 to 29","30 to 35","36 to 41", "42 to 47","48 to 53","54 to 59","60 to 65","66 to 70"]
    var placesTableView: UITableView  =   UITableView()
    var objectIdArr:[AnyObject] = [AnyObject]()
    var placesArr: [AnyObject] = [AnyObject]()
    var JSON_DICT:NSDictionary = [:]
    
    var host = Firebase(url:"https://shabbatapp.firebaseio.com/HOST")
    var locationArr: [AnyObject] = [AnyObject]()
    var dict:NSDictionary?
    var menuBtn = 0
    
    var arr1 = NSMutableArray()
    let button = UIButton(type: .Custom)

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dateAndTimePicker.hidden = true
        DoneBtnView.hidden = true
        agePicker.hidden = true
        
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
             
        dateTxtFld.attributedPlaceholder = NSAttributedString(string:"Date",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        ageTxtFld.attributedPlaceholder = NSAttributedString(string:"Age",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        locTxtFld.attributedPlaceholder = NSAttributedString(string:"Location",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        kosherFld.attributedPlaceholder = NSAttributedString(string:"Kosher",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        seatFld.attributedPlaceholder = NSAttributedString(string:"Number of spots seeking",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        locTxtFld.addTarget(self, action:#selector(SeekVC.edited), forControlEvents:UIControlEvents.EditingChanged)
        
        placesTableView.frame   =   CGRectMake(locTxtFld.frame.origin.x, locTxtFld.frame.origin.y+locTxtFld.frame.height, locTxtFld.frame.width, locTxtFld.frame.height*5);
        placesTableView.backgroundColor = UIColor.whiteColor()
        placesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.placesTableView.dataSource = self
        self.placesTableView.delegate = self
        self.view.addSubview(placesTableView)
        placesTableView.hidden = true
    
        
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "SEARCH"
        nav1Lbl.font = UIFont(name: "Helvetica-Bold", size: 19)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        button.addTarget(self, action:#selector(SeekVC.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(SeekVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn

        agePicker.backgroundColor = UIColor.whiteColor()
        dateAndTimePicker.backgroundColor = UIColor.whiteColor()
               

    }
    
 
    
    func openSetting()
    {
        print("Setting icon is tapped")
        let updateVC = (self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
        updateVC.update = "UPDATE"
        updateVC.user_ID = user_id
        self.navigationController?.pushViewController(updateVC, animated: true)
        
    }
    
    //MARK: method to add lines
    func addLineMethod(xAxis:CGFloat, yAxis: CGFloat, width: CGFloat, height: CGFloat)
    {
        let line: UIView = UIView()
        line.frame=CGRectMake(xAxis, yAxis, width, height)
        line.backgroundColor=UIColor.grayColor()
        self.view.addSubview(line)
    }
    
    @IBAction func DoneBtnAction(sender: AnyObject)
    {
        dateAndTimePicker.hidden = true
        DoneBtnView.hidden = true
        agePicker.hidden = true
    }
    
    func openDrawer()
    {
        if (menuBtn==0)
        {
            button.setImage(UIImage(named: "cross"), forState: .Normal)
            menuBtn += 1
        }
        else
        {
            button.setImage(UIImage(named: "menu"), forState: .Normal)
            menuBtn -= 1
        }
        
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

        //self.navigationController?.popViewControllerAnimated(true)
    }
    

    //MARK:  autocomplete table view datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return placesArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        for object in cell.contentView.subviews
        {
            object.removeFromSuperview();
        }
                
        //Label in cell
        let label = UILabel(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        label.text = placesArr[indexPath.row].objectForKey("Address") as? String
        label.backgroundColor = UIColor.yellowColor()
        cell.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(label)
        
        
        return cell
    }
    
    //MARK:  autocomplete table view delegates
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        locTxtFld.text = placesArr[indexPath.row].objectForKey("Address") as? String
        placesTableView.hidden = true
    }
    
    
    
    
    
    func edited()
    {
        keyboardWasShown()
        self.apiFunction(locTxtFld.text!)
        placesTableView.hidden = false
    }
//    
    func keyboardWasShown()
    {
//        var info = notification.userInfo!
//        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.locTxtFld.frame = CGRectMake(10, 50, 300, self.view.frame.size.height-400)
           // self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }

    

    //MARK:  search method to find shabbat dinner places
    @IBAction func searchBtnAction(sender: AnyObject)
    {
        if dateTxtFld.text == ""
        {
           self.alertShowMethod("", message: "Please select date")
        }
        else
        {
            host.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    
                    
                    print(snapshot.value.count)
                    
                    
                    self.dict = snapshot.value as? NSDictionary
                    //print(self.dict)
                    
                    
                    let all_user:NSArray =  self.dict!.allKeys
                    
                    print(all_user)
                    var result = 0
                    
                    for i in 0 ..< Int(all_user.count)
                    {
                        //print(self.dict!.objectForKey(all_user.objectAtIndex(i)))
                        
                        let dinner: NSArray = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.allKeys)!
                        for j in 0 ..< Int(dinner.count)
                        {
                            let date = self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("date") as! String
                            
                            if self.dateTxtFld.text == date
                            {
                                result = 1
                                
                                let location = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("location_id")) as! String
                                
                                let seats = (self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("seats")) as! String
                                
                                let usrID = all_user.objectAtIndex(i) as! String
                           
                                let data:NSDictionary = NSDictionary(objects:[location , seats,usrID], forKeys:["location" , "seats" , "user_id"])
                                
                                
                                self.locationArr.append(data)
                                print(self.locationArr)
                                
                                print("Yes this is match")
                            }
                            
                            
                            print(self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey(dinner.objectAtIndex(j))?.objectForKey("date"))
                        }
                        
                    }
                    
                    if result == 0
                    {
                        self.alertShowMethod("", message: "No Shabbat Dinner for this date")
                    }
                    
                    else
                    {
                       let mapVC = (self.storyboard!.instantiateViewControllerWithIdentifier("GoogleMapVC")) as! GoogleMapVC
                       mapVC.user_id = self.user_id
                       mapVC.placeIdArr = self.locationArr
                       self.navigationController?.pushViewController(mapVC, animated: true)
                    
                    }                    
            })
        }
    }

    
    
    //Mark: Datasourse methods of picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return ageRange.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return ageRange[row]
    }
    
    //Mark: Delegate method of picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        ageTxtFld.text=ageRange[row]
    }

    
    @IBAction func dateAndTimePickerMethod(sender: AnyObject)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.stringFromDate(dateAndTimePicker.date)
        dateTxtFld.text = strDate
    }

    @IBAction func datePicBtn(sender: AnyObject)
    {
        self.view.endEditing(true)
        agePicker.hidden = true
        dateAndTimePicker.hidden = false
        DoneBtnView.hidden = false
        
    }
    
    @IBAction func agePickMethed(sender: AnyObject)
    {
        self.view.endEditing(true)
        dateAndTimePicker.hidden = true
        agePicker.hidden = false
        DoneBtnView.hidden = false
        
    }
    
    //MARK:  api function for autocomplete for places
    func apiFunction(typpedStr: String)
    {
        var mutString = NSString(string: typpedStr)
        
        mutString = mutString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + (mutString as String) + "&types=address&language=fr&key=%20AIzaSyAqRxlbGhWi8TgHda6K23JRcTJciPmkBBc")
            let request = NSURLRequest(URL: url!)
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                
                self.placesArr.removeAll()                
                do
                {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                    {
                        print(jsonResult)
                        
                        let arr:NSArray = jsonResult["predictions"] as! NSArray
                        
                        
                        for i in 0 ..< Int((jsonResult["predictions"]?.count)!)
                        {
                            
                            let dic:NSMutableDictionary = arr.objectAtIndex(i) as! NSMutableDictionary
                            
                            let dic1:NSMutableDictionary = [:]
                            dic1.setValue(dic["description"], forKey: "Address")
                            dic1.setValue(dic["place_id"], forKey: "Place_ID")
                            self.placesArr.append(dic1)
                        }
                        
                        print(self.placesArr)
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                self.placesTableView.reloadData()
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

    @IBAction func kosherSwitchAction(sender: AnyObject)
    {
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: alert method
    func alertShowMethod(Title:String, message:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //Handle KeyPad hide or show and picker and date picker also
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        dateAndTimePicker.hidden = true
        agePicker.hidden = true
        DoneBtnView.hidden = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }
    
    
    
    
   //api to find lat long using address https://maps.googleapis.com/maps/api/geocode/json?address=Paris%20Avenue,%20Earlwood,%20New%20South%20Wales,%20Australia&sensor=false
    
    
    // MARK: - Navigation

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
//    {
//        if (segue.identifier == "MapVC") {
//            //Checking identifier is crucial as there might be multiple
//            // segues attached to same view
//            let detailVC = segue.destinationViewController as! MapVC;
//            detailVC.placeIdArr = objectIdArr
//        }
//    }

}
