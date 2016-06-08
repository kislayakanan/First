//
//  SearchVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/20/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class SearchVC: UIViewController,UIPickerViewDelegate
{
    var user_id: String?
    var kosherString = "YES"
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
    var ref = FIRDatabase.database().reference()
    
   // var host = Firebase(url:"https://shabbatapp.firebaseio.com/HOST")
    var dict:NSDictionary?
    var menuBtn = 0
    var arr1 = NSMutableArray()
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        selectedLocation = ""
        selectedLocationId = ""
        
        
        dateAndTimePicker.hidden = true
        DoneBtnView.hidden = true
        agePicker.hidden = true
        
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
             
        dateTxtFld.attributedPlaceholder = NSAttributedString(string:"Date",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        ageTxtFld.attributedPlaceholder = NSAttributedString(string:"Age",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        locTxtFld.attributedPlaceholder = NSAttributedString(string:"Location",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        kosherFld.attributedPlaceholder = NSAttributedString(string:"Kosher",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        seatFld.attributedPlaceholder = NSAttributedString(string:"Number of spots seeking",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "SEARCH"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(SearchVC.openDrawer), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "menu"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        let settingBtn = UIButton(type: .Custom)
        settingBtn.addTarget(self, action:#selector(SearchVC.openSetting), forControlEvents: .TouchUpInside)
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
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
       
    }

    //MARK:  search method to find shabbat dinner places
    @IBAction func searchBtnAction(sender: AnyObject)
    {
        if ReachabilityNet.isConnectedToNetwork() == true
        {
            print("Internet connection OK")

            let mapVC = (self.storyboard!.instantiateViewControllerWithIdentifier("SeekVC")) as! SeekVC
            mapVC.search = "SEARCH"
            mapVC.date = dateTxtFld.text!
            mapVC.age = ageTxtFld.text!
            mapVC.seats = seatFld.text!
            mapVC.place = locTxtFld.text!
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
        else
        {
            self.alertShowMethod("Internet connection error", message: "Please try again")
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

    @IBAction func kosherSwitchAction(sender: UISwitch)
    {
        if sender.on == true
        {
            print(kosherString)
            kosherString = "YES"
        }
        else
        {
            print(kosherString)
            kosherString = "NO"
        }
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        if selectedLocation != ""
        {
           locTxtFld.text = selectedLocation
        }
        
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
    

     
     //MARK: To Location search
     func textFieldDidBeginEditing(textField: UITextField)
     {
       if textField == locTxtFld
       {
         let presentSearchVC = (self.storyboard!.instantiateViewControllerWithIdentifier("PresentSerachViewController")) as UIViewController
     
        self.presentViewController(presentSearchVC, animated: true, completion: nil)
       }
     }
 


}
