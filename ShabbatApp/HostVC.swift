//
//  HostVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/20/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class HostVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource
{
   
    @IBOutlet var kosherFld: UITextField!
    @IBOutlet var kosherSwitch: UISwitch!
    var user_id: String?
    var dinnerID:String?
    var updateDinner: String?
    @IBOutlet var timeTxtFld: UITextField!
    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var doneView: UIView!
    @IBOutlet var seatTxtFld: UITextField!
    @IBOutlet var locationTxtFld: UITextField!
    @IBOutlet var tag_lineTxtFld: UITextField!
    @IBOutlet var ageTxtFld: UITextField!
    @IBOutlet var dateTxtFld: UITextField!
    @IBOutlet var dateBtn: UIButton!
    @IBOutlet var agePicker: UIPickerView!
    @IBOutlet var dateAndTimePicker: UIDatePicker!    
    @IBOutlet var createDinnerBtn: UIButton!
    var kosherString = "YES"
    var datePickerBtnTag = Int()
    var pickerBtnTag = Int()
    var location_id_str:NSString!

    var ageRange = ["18 and under","19 to 23","24 to 29","30 to 35","36 to 41", "42 to 47","48 to 53","54 to 59","60 to 65","66 to 70"]
    var seats = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"]
    
    
    //var ref = Firebase(url:"https://shabbatapp.firebaseio.com")
    var ref = FIRDatabase.database().reference()
    
    //var host = Firebase(url:"https://shabbatapp.firebaseio.com/HOST")
    //var host = ref.child("HOST")
    
    //var users = Firebase(url:"https://shabbatapp.firebaseio.com/USERS")
    let button = UIButton(type: .Custom)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
                
        selectedLocation = ""
        selectedLocationId = ""
        user_id = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
        
        agePicker.hidden = true
        dateAndTimePicker.hidden = true
        doneView.hidden = true
        
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        
        seatTxtFld.attributedPlaceholder = NSAttributedString(string:"Choose Seats",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        locationTxtFld.attributedPlaceholder = NSAttributedString(string:"Location",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        dateTxtFld.attributedPlaceholder = NSAttributedString(string:"Date",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        timeTxtFld.attributedPlaceholder = NSAttributedString(string:"Time",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        tag_lineTxtFld.attributedPlaceholder = NSAttributedString(string:"Tagline",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        ageTxtFld.attributedPlaceholder = NSAttributedString(string:"Age",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        kosherFld.attributedPlaceholder = NSAttributedString(string:"Kosher",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        //timeTxtFld.addTarget(self, action: "timePickerOpen:", forControlEvents: UIControlEvents.EditingChanged)
        //timeTxtFld.delegate = self
        
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl

        //button.tintColor =[UIColor blackColor];
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn        
        
        if updateDinner == "UPDATE_DINNER"
        {
            nav1Lbl.text = "UPDATE DINNER"
            button.addTarget(self, action:#selector(HostVC.backMethod), forControlEvents: .TouchUpInside)
            button.setImage(UIImage(named: "backicon"), forState: .Normal)
            //createDinnerBtn.setTitle("Update Dinner", forState: .Normal)
           createDinnerBtn.setImage(UIImage(named: "dinner_update"), forState: .Normal)
            let host = ref.child("HOST")
            let userID = host.child(user_id!)
            let dinner_data = userID.child(dinnerID!)
            //let dinner_data = Firebase(url:"https://shabbatapp.firebaseio.com/HOST/" + user_id! + "/" + dinnerID!)
            dinner_data.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    let dict = snapshot.value as? NSDictionary
                    print(dict)
                    
                    self.ageTxtFld.text = dict!.objectForKey("age") as? String
                    self.locationTxtFld.text = dict!.objectForKey("location") as? String
                    self.seatTxtFld.text = dict!.objectForKey("seats") as? String
                    self.tag_lineTxtFld.text = dict!.objectForKey("tagline") as? String
                    self.timeTxtFld.text = dict!.objectForKey("time") as? String
                    self.dateTxtFld.text = dict!.objectForKey("date") as? String
                    
                    
            })
            
            
            
            
            
        }
        else
        {
            nav1Lbl.text = "HOST"
            button.addTarget(self, action:#selector(HostVC.openDrawer), forControlEvents: .TouchUpInside)
            button.setImage(UIImage(named: "menu"), forState: .Normal)
        }
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(HostVC.openSetting), forControlEvents: .TouchUpInside)
        settingBtn.setImage(UIImage(named: "setting-icon"), forState: .Normal)
        //    button.tintColor =[UIColor blackColor];
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: settingBtn)
        self.navigationItem.rightBarButtonItem = sBarBtn
        
           
        dateAndTimePicker.backgroundColor = UIColor.whiteColor()
        
    }
    
    
//    func timePickerOpen()
//    {
//        self.view.endEditing(true)
//        //datePickerBtnTag = sender.tag
//        agePicker.hidden = true
//        dateAndTimePicker.hidden = false
//        dateAndTimePicker.datePickerMode = .Time
//        doneView.hidden = false
//    }
    
    func backMethod()
    {
        self.navigationController?.popViewControllerAnimated(true)
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
        hostOrSeek = "HOST"
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
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
    }
    
    
    
    
   
    
   //MARK: create new Shabbat dinner or update shabbat dinner
    @IBAction func createNewShabbatDinnerMethod(sender: AnyObject)
    {
        
      if ReachabilityNet.isConnectedToNetwork() == true
       {
        print("Internet connection OK")
        
        if seatTxtFld.text == "" || locationTxtFld.text == "" || tag_lineTxtFld.text == "" || timeTxtFld.text == "" || dateTxtFld.text == "" || ageTxtFld.text == ""
        {
            self.alertShowMethod("", message: "Please fill all fields")
        }
        
        // To update Shabbat dinner
        else if updateDinner == "UPDATE_DINNER"
        {
            print(dinnerID)
            
            let host = ref.child("HOST")
            let userID = host.child(user_id!)
            let dinner_data = userID.child(dinnerID!)
            
            //let dinner_data = Firebase(url:"https://shabbatapp.firebaseio.com/HOST/" + user_id! + "/" + dinnerID!)
            let data =
                [
                    "user_id":user_id!,
                    "seats":self.seatTxtFld.text!,
                    "location":self.locationTxtFld.text!,
                    "date":self.dateTxtFld.text!,
                    "time":self.timeTxtFld.text!,
                    "tagline":self.tag_lineTxtFld.text!,
                    "age":self.ageTxtFld.text!
            ]
            
            dinner_data.updateChildValues(data)            
            self.navigationController?.popViewControllerAnimated(true)
            self.alertShowMethod("", message: "Shabbat dinner is updated")
        }
            
        else
        {
            //let usr = Firebase(url:"https://shabbatapp.firebaseio.com/HOST/" + user_id!)
            let host = ref.child("HOST")
            let usr = host.child(user_id!)
            let newDinnerData = usr.childByAutoId()
            
            let data =
                      [
                        "user_id":user_id!,
                        "seats":self.seatTxtFld.text!,
                        "location":self.locationTxtFld.text!,
                        "location_id":selectedLocationId,
                        "date":self.dateTxtFld.text!,
                        "time":self.timeTxtFld.text!,
                        "tagline":self.tag_lineTxtFld.text!,
                        "age":self.ageTxtFld.text!,
                        "kosher":self.kosherString
                      ]
            
            newDinnerData.setValue(data, withCompletionBlock:
            {
                (error:NSError?, firebase:FIRDatabaseReference!) in
                if (error != nil)
                {
                    print("Data could not be saved.")
                    self.alertShowMethod("", message: "Your shabbat dinner is not created")
                }
                else
                {
                    print("Data saved successfully!")
                    self.alertShowMethod("", message: "Successfully created your shabbat dinner")
                    self.seatTxtFld.text = ""
                    self.locationTxtFld.text = ""
                    self.dateTxtFld.text = ""
                    self.timeTxtFld.text = ""
                    self.tag_lineTxtFld.text = ""
                    self.ageTxtFld.text = ""                      
                    
                }
            })
            
        }
      }
      else
      {
        self.alertShowMethod("Internet connection error", message: "Please try again")
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
        if selectedLocation != ""
        {
            locationTxtFld.text = selectedLocation
        }
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
    }
    
    
    //MARK: alert method
    func alertShowMethod(Title:String, message:String)
    {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Condition for create Successfully dinner
        if message == "Successfully created your shabbat dinner" || message == "Shabbat dinner is updated"
        {
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                let hostList = (self.storyboard!.instantiateViewControllerWithIdentifier("HostDinnerListVC")) as! HostDinnerListVC
                self.navigationController?.pushViewController(hostList, animated: true)
                
            }
            alert.addAction(okAction)
        }
        else
        {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    

    //MARK: To Location search 
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == locationTxtFld
        {
            let presentSearchVC = (self.storyboard!.instantiateViewControllerWithIdentifier("PresentSerachViewController")) as UIViewController
            
            self.presentViewController(presentSearchVC, animated: true, completion: nil)
        }

        
    }
    
    //Handle KeyPad hide or show and picker and date picker also
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        dateAndTimePicker.hidden = true
        agePicker.hidden = true
        doneView.hidden = true
        return true
    }
    
    //Methods for dismiss keypad
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func kosherSwitchAction(sender: UISwitch) {
       
        if sender.on == true
        {
            print("On")
            kosherString = "YES"
        }
        else
        {
            print("Off")
            kosherString = "NO"
        }
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
