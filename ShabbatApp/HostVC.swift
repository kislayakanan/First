//
//  HostVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/20/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class HostVC: UIViewController,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource
{
    var k = 1
    var user_id: String?
    @IBOutlet var timeTxtFld: UITextField!
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var doneView: UIView!
    @IBOutlet var seatTxtFld: UITextField!
    @IBOutlet var locationTxtFld: UITextField!
    @IBOutlet var tag_lineTxtFld: UITextField!
    @IBOutlet var dateBtn: UIButton!
    @IBOutlet var agePicker: UIPickerView!
   
    @IBOutlet var dateAndTimePicker: UIDatePicker!
    
    var placesTableView: UITableView  =   UITableView()
    var datePickerBtnTag = Int()
    var pickerBtnTag = Int()
    var menuBtn = 0
   
    @IBOutlet var ageTxtFld: UITextField!
    

    @IBOutlet var dateTxtFld: UITextField!
    var location_id_str:NSString!
    
    
    var placesArr: [AnyObject] = [AnyObject]()
    var ageRange = ["18 and under","19 to 23","24 to 29","30 to 35","36 to 41", "42 to 47","48 to 53","54 to 59","60 to 65","66 to 70"]
    var seats = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"]
    
    
    var ref = Firebase(url:"https://shabbatapp.firebaseio.com")
    var host = Firebase(url:"https://shabbatapp.firebaseio.com/HOST")
    let button = UIButton(type: .Custom)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        print(locationTxtFld.frame.origin.y)
        print(locationTxtFld.frame.origin.x)
        print(locationTxtFld.frame.height)
        print(locationTxtFld.frame.width)
        
        
        
        agePicker.hidden = true
        dateAndTimePicker.hidden = true
        doneView.hidden = true
        
        //print(navigationController!.navigationBar.frame.height)
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        
        seatTxtFld.attributedPlaceholder = NSAttributedString(string:"Choose Seats",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        locationTxtFld.attributedPlaceholder = NSAttributedString(string:"Locaton",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        dateTxtFld.attributedPlaceholder = NSAttributedString(string:"Date",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        timeTxtFld.attributedPlaceholder = NSAttributedString(string:"Time",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        tag_lineTxtFld.attributedPlaceholder = NSAttributedString(string:"Tagline",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        ageTxtFld.attributedPlaceholder = NSAttributedString(string:"Age",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        
        //for autocomplete for places
        locationTxtFld.addTarget(self, action:#selector(edited), forControlEvents:UIControlEvents.EditingChanged)
        
        
        placesTableView.frame   =   CGRectMake(locationTxtFld.frame.origin.x, locationTxtFld.frame.origin.y+locationTxtFld.frame.height, locationTxtFld.frame.width, locationTxtFld.frame.height*4);
        placesTableView.backgroundColor = UIColor.whiteColor()
        placesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.placesTableView.dataSource = self
        self.placesTableView.delegate = self
        self.view.addSubview(placesTableView)
        placesTableView.hidden = true
        
        
 
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "HOST"
        nav1Lbl.font = UIFont(name: "Helvetica-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        
        button.addTarget(self, action:#selector(HostVC.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        //    button.tintColor =[UIColor blackColor];
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(HostVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        //    button.tintColor =[UIColor blackColor];
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn
        
           
        dateAndTimePicker.backgroundColor = UIColor.whiteColor()
        
    }
    
    @IBAction func DoneBtnAction(sender: AnyObject)
    {
        dateAndTimePicker.hidden = true
        agePicker.hidden = true
        doneView.hidden = true
    }
    
    
    //MARK: method to add lines
    func addLineMethod(xAxis:CGFloat, yAxis: CGFloat, width: CGFloat, height: CGFloat)
    {
        let line: UIView = UIView()
        line.frame=CGRectMake(xAxis, yAxis, width, height)
        line.backgroundColor=UIColor.grayColor()
        self.view.addSubview(line)
    }
    
    func openSetting()
    {
        print("Setting icon is tapped")
        let updateVC = (self.storyboard!.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
        updateVC.update = "UPDATE"
        updateVC.user_ID = user_id
        self.navigationController?.pushViewController(updateVC, animated: true)
        
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
        label.backgroundColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(label)
        
        
        return cell
    }
    
    //MARK:  autocomplete table view delegates methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        locationTxtFld.text = placesArr[indexPath.row].objectForKey("Address") as? String
        location_id_str = placesArr[indexPath.row].objectForKey("Place_ID") as? String
        self.locationTxtFld.frame = CGRectMake(self.view.frame.width/12.8,self.view.frame.height/1.73913, self.view.frame.width/1.3333333333,self.view.frame.height/18.8235294)
        self.locationTxtFld.backgroundColor = UIColor.clearColor()
        self.view.endEditing(true)
        placesTableView.hidden = true
        

        
    }
    
    func keyboardWasShown()
    {
        //        var info = notification.userInfo!
        //        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.locationTxtFld.frame = CGRectMake(10, 150, self.view.frame.size.width-20, self.view.frame.height/16)
             self.locationTxtFld.backgroundColor = UIColor.blackColor()
              self.placesTableView.frame   =   CGRectMake(10,150+self.view.frame.height/16, self.view.frame.size.width-20, self.view.frame.height-150+self.view.frame.height/16);
            self.view.bringSubviewToFront(self.placesTableView)
            self.view.bringSubviewToFront(self.locationTxtFld)
            
            
        })
    }

    
    
    
    
    func edited()
    {
        keyboardWasShown( )
        if locationTxtFld.text == ""
        {
         placesTableView.hidden = true
        locationTxtFld.frame = CGRectMake(self.view.frame.width/12.8,self.view.frame.height/1.73913, self.view.frame.width/1.3333333333,self.view.frame.height/18.8235294)
        locationTxtFld.backgroundColor = UIColor.clearColor()
         
        }
        else
        {
            self.apiFunction(locationTxtFld.text!)
            placesTableView.hidden = false
        }
        
    }
    

    
       
    

    //Mark: Datasourse methods of picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        print(pickerBtnTag)
        
        
        if pickerBtnTag == 222
        {
           return ageRange.count
        }
        else if pickerBtnTag == 223
        {
            return seats.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        
        if pickerBtnTag == 222
        {
            return ageRange[row]
        }
        else
        {
            return seats[row]
        }
        
        
    }

    //Mark: Delegate method of picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        
        if pickerBtnTag == 222
        {
            ageTxtFld.text=ageRange[row]
        }
        else
        {
           seatTxtFld.text=seats[row]
        }
        
        //agePicker.hidden = true
    }
    
    
    
    
   
    
   //MARK: create new Shabbat dinner
    @IBAction func createNewShabbatDinnerMethod(sender: AnyObject)
    {
        if seatTxtFld.text == "" || locationTxtFld.text == "" || tag_lineTxtFld.text == "" || timeTxtFld.text == "" || dateTxtFld.text == ""
        {
           self.alertShowMethod("", message: "Please fill all Feilds")
        }
            
        else
        {
            let usr = Firebase(url:"https://shabbatapp.firebaseio.com/HOST/" + user_id!)
            let newDinnerData = usr.childByAutoId()
            
            let data =
                      [
                        "user_id":user_id!,
                        "seats":self.seatTxtFld.text!,
                        "location":self.locationTxtFld.text!,
                        "location_id":location_id_str,
                        "date":self.dateTxtFld.text!,
                        "time":self.timeTxtFld.text!,
                        "tagline":self.tag_lineTxtFld.text!,
                      ]
            
            newDinnerData.setValue(data, withCompletionBlock:
            {
                (error:NSError?, firebase:Firebase!) in
                if (error != nil)
                {
                    print("Data could not be saved.")
                    self.alertShowMethod("", message: "Not created your Shabbat Dinner")
                }
                else
                {
                    print("Data saved successfully!")
                    self.alertShowMethod("", message: "SuccessFully created your Shabbat Dinner")
                }
            })
            
        }
    }
    
    @IBAction func agePicBtn(sender: AnyObject)
    {
        self.view.endEditing(true)
        print(sender.tag)
        pickerBtnTag = sender.tag
        agePicker.dataSource = self
        agePicker.delegate = self
        doneView.hidden = false
        dateAndTimePicker.hidden = true
        agePicker.hidden = false
    }
    
    @IBAction func datePicBtn(sender: AnyObject)
    {
        self.view.endEditing(true)
        print(sender.tag)
        datePickerBtnTag = sender.tag
        agePicker.hidden = true
        dateAndTimePicker.hidden = false
        dateAndTimePicker.datePickerMode = .Date
        doneView.hidden = false
    }
    
    
    @IBAction func datePicMethod(sender: AnyObject)
    {
        
        
        if datePickerBtnTag == 111
        {
            print("date pic button is tapped")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let strDate = dateFormatter.stringFromDate(dateAndTimePicker.date)
            dateTxtFld.text = strDate
        }
        else if datePickerBtnTag == 112
        {
            print("time pic button is tapped")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let strDate = dateFormatter.stringFromDate(dateAndTimePicker.date)
            timeTxtFld.text = strDate
        }
        

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

    
    @IBAction func timePicAction(sender: AnyObject)
    {
        
        print(sender.tag)
        self.view.endEditing(true)
        datePickerBtnTag = sender.tag
        agePicker.hidden = true
        dateAndTimePicker.hidden = false
        dateAndTimePicker.datePickerMode = .Time
        doneView.hidden = false
    }
    
    @IBAction func seatPicAction(sender: AnyObject)
    {
        print(sender.tag)
        self.view.endEditing(true)
        pickerBtnTag = sender.tag
        agePicker.dataSource = self
        agePicker.delegate = self
        doneView.hidden = false
        dateAndTimePicker.hidden = true
        agePicker.hidden = false
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
        doneView.hidden = true
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
