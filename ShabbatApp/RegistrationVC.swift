//
//  RegistrationVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/19/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//


import UIKit

class RegistrationVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate
{
    @IBOutlet var editprofilepicBtn: UIButton!
    @IBOutlet var profile_updatePic: UIImageView!
    @IBOutlet var ageBtn: UIButton!
    @IBOutlet var updateBG: UIImageView!
    @IBOutlet var registrationLogo: UIImageView!
    
    @IBOutlet var genderIcon: UIImageView!
    @IBOutlet var registrationLbl: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var DoneView: UIView!
    @IBOutlet var picBtn: UIButton!
 
    @IBOutlet var profilePicture: UIButton!
    @IBOutlet var distanceLbl: UILabel!
    var USER: String?
    var update: String?
    var user_ID: String?
    var responseResult: AnyObject?
    @IBOutlet var fullName: UITextField!
    @IBOutlet var emailFld: UITextField!
    @IBOutlet var userNameFld: UITextField!
    @IBOutlet var passwordFld: UITextField!
    @IBOutlet var genderFld: UITextField!
    @IBOutlet var ageFld: UITextField!
    @IBOutlet var locFld: UITextField!
    @IBOutlet var distanceFld: UITextField!
    @IBOutlet var statusFld: UITextField!
    @IBOutlet var tagLineFld: UITextField!    
    @IBOutlet var profilePic: UIButton!
    @IBOutlet var agePicker: UIPickerView!
    var dict:NSDictionary?
    var nav1Lbl = UILabel()
    var boolvalue = Bool()
    var isExist = "NotExist"
    var imag = 0
    var strValue = ""
    
    //let postRef = ref.child("posts")
    //var ref = Firebase(url:"https://shabbatapp.firebaseio.com")
    var ref = FIRDatabase.database().reference()
    //var users = Firebase(url:"https://shabbatapp.firebaseio.com/USERS")
    //var user_cast = Firebase(url:"https://shabbatapp.firebaseio.com/USERCAST")
    //var images = Firebase(url:"https://shabbatapp.firebaseio.com/IMAGES")
    
    
    let imagePicker = UIImagePickerController()
     var placesTableView: UITableView  =   UITableView()
    var placesArr: [AnyObject] = [AnyObject]()
    
   
 
    var ageRange = ["10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70"]
    
    @IBAction func openMediaUpdate(sender: UIButton)
    {
        self.openMediaMethod("hello")
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        selectedLocation = ""
        selectedLocationId = ""
        //Current user id 
        user_ID = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String
        
        
        
        
        editprofilepicBtn.hidden = true
        editprofilepicBtn.userInteractionEnabled = false
        profile_updatePic.clipsToBounds = true
        profile_updatePic.layer.cornerRadius = 0.5 * profile_updatePic.bounds.size.width
        profile_updatePic.hidden = true
        
        distanceLbl.text = "50 Miles"
        
        fullName.attributedPlaceholder = NSAttributedString(string:"Full Name*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailFld.attributedPlaceholder = NSAttributedString(string:"Email*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        userNameFld.attributedPlaceholder = NSAttributedString(string:"Username*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordFld.attributedPlaceholder = NSAttributedString(string:"Password*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        genderFld.attributedPlaceholder = NSAttributedString(string:"Gender*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        ageFld.attributedPlaceholder = NSAttributedString(string:"Age*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        distanceFld.attributedPlaceholder = NSAttributedString(string:"Distance willing to travel*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        locFld.attributedPlaceholder = NSAttributedString(string:"Location*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        tagLineFld.attributedPlaceholder = NSAttributedString(string:"Tagline*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        statusFld.attributedPlaceholder = NSAttributedString(string:"Status*",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        
        
        print(USER)
        agePicker.hidden=true
        DoneView.hidden = true
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "Registration"
        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(RegistrationVC.backMethod), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "backicon"), forState: .Normal)
        //    button.tintColor =[UIColor blackColor];
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        

        
        placesTableView.frame   =   CGRectMake(0, locFld.frame.origin.y+locFld.frame.height, self.view.frame.width, self.view.frame.height-locFld.frame.origin.y-locFld.frame.height);
        placesTableView.backgroundColor = UIColor.whiteColor()
        placesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.placesTableView.dataSource = self
        self.placesTableView.delegate = self
        self.view.addSubview(placesTableView)
        placesTableView.hidden = true
        profilePicture.clipsToBounds = true
        profilePicture.layer.cornerRadius = 0.5 * profilePicture.bounds.size.width
        
    }
    
    
    @IBAction func DoneBtnAction(sender: AnyObject)
    {
        agePicker.hidden = true
        DoneView.hidden = true
    }
    
    @IBAction func openMediaMethod(sender: AnyObject)
    {
        let actionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title:"Take photo", style:UIAlertActionStyle.Default, handler:
            { action in
               self.takePhotoAction()
             }
            ))
        actionSheet.addAction(UIAlertAction(title:"Open Gallery", style:UIAlertActionStyle.Default, handler:{ action in
            self.openGallery()
        }))
        actionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        presentViewController(actionSheet, animated:true, completion:nil)
    }
    
    func takePhotoAction()
    {
       print("open Cammera")
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        else
        {
            self.alertShowMethod("Error", message: "Camera not available")
        }

    }
    func openGallery()
    {
        print("open Gallary")
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func distancePickerMethod(sender: UISlider)
    {
        self.view.endEditing(true)
       let value = Int(sender.value)
        distanceLbl.text = "\(value) Miles"
    }
    override func viewWillAppear(animated: Bool)
    {
        if (selectedLocation != "")
        {
            locFld.text = selectedLocation
        }
        else
        {
        if update == "UPDATE" && imag == 0
        {
            editprofilepicBtn.hidden = false
            profile_updatePic.hidden = false
            profilePicture.hidden = true
            ageBtn.setImage(UIImage(named: "dropdown"), forState: .Normal)
            
            
            //Activity Controller
            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            myActivityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75)
            myActivityIndicator.center = self.view.center
            myActivityIndicator.startAnimating()
            self.view.addSubview(myActivityIndicator)
            
            
            updateBG.image = UIImage(named: "profile-bg")
            registrationLogo.hidden = true
            registrationLbl.hidden = true
            nav1Lbl.text = "UPDATE"
            genderIcon.image = UIImage(named: "edit-gender")
            navigationController!.navigationBar.barTintColor = UIColor.orangeColor()
            emailFld.userInteractionEnabled = false
            userNameFld.userInteractionEnabled = false
            
            let users = ref.child("USERS")
            users.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    
                    self.dict = snapshot.value as? NSDictionary
                    //Check result first
                    if self.dict != nil
                    {
                        if self.dict?.objectForKey(self.user_ID!) != nil
                        {
                            self.fullName.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("fullname") as? String
                            self.userNameFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("username") as? String
                            self.emailFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("email") as? String
                            self.genderFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("gender") as? String
                            self.ageFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("age") as? String
                            self.passwordFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("password") as? String
                            self.locFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("location") as? String
                            let distanceStr = self.dict?.objectForKey(self.user_ID!)?.objectForKey("distance") as? String
                            self.distanceLbl.text = distanceStr
                            var token = distanceStr!.componentsSeparatedByString(" ")
                            let val = Float(token[0])
                            self.slider.value = val!
                            self.statusFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("status") as? String
                            self.tagLineFld.text = self.dict?.objectForKey(self.user_ID!)?.objectForKey("tagline") as? String
                            myActivityIndicator.stopAnimating()
                        }
                        else
                        {
                            myActivityIndicator.stopAnimating()
                            self.alertShowMethod("", message: "User data not found")
                        }
                    }

                    
            })
            
            
            //Activity Controller
            let myActivityIndicator1 = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            myActivityIndicator1.transform = CGAffineTransformMakeScale(0.75, 0.75)
            myActivityIndicator1.center = profile_updatePic.center
            myActivityIndicator1.startAnimating()
            self.view.addSubview(myActivityIndicator1)
            
            let images = ref.child("IMAGES")
            images.observeEventType(.Value, withBlock:
                {
                    snapshot in
                    self.dict = snapshot.value as? NSDictionary
                    if self.dict != nil
                    {
                        if self.dict?.objectForKey(self.user_ID!) != nil
                        {
                            let base64EncodedString = self.dict?.objectForKey(self.user_ID!)?.objectForKey("profile_pic")
                            
                            let imageData = NSData(base64EncodedString: base64EncodedString as! String,
                                options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            let decodedImage = UIImage(data:imageData!)
                            self.profile_updatePic.image = decodedImage
                            myActivityIndicator1.stopAnimating()
                            self.editprofilepicBtn.userInteractionEnabled = true
                            
                        }
                        else
                        {
                            myActivityIndicator1.stopAnimating()
                            self.alertShowMethod("", message: "Profile picture not available")
                        }
                    }
            })
            
            registerBtn.setImage(UIImage(named: "update-button"), forState: .Normal)
        }
      }
    
    }
    
    @IBAction func genderMethod(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        if sender.tag == 25
        {
            genderFld.text = "Male"
        }
        else if sender.tag == 24
        {
            genderFld.text = "Female"
        }
        
    }
    func edited()
    {
        
        self.apiFunction(locFld.text!)
        placesTableView.hidden = false
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
    
    //MARK:  autocomplete table view delegates
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        locFld.text = placesArr[indexPath.row].objectForKey("Address") as? String
        placesTableView.hidden = true
    }

    
    
    //add line methods
    func addLineMethod(xAxis:CGFloat, yAxis: CGFloat, width: CGFloat, height: CGFloat)
    {
        let line: UIView = UIView()
        line.frame=CGRectMake(xAxis, yAxis, width, height)
        line.backgroundColor=UIColor.grayColor()
        self.view.addSubview(line)
    }
    
    
    func backMethod()
    {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.view.endEditing(true)
    }


    //Mark: Picker datasource methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return ageRange.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return ageRange[row]
    }
    
    //Mark: Delegate method of picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        ageFld.text=ageRange[row]
    }
    
    @IBAction func ageBtn(sender: AnyObject)
    {
        self.view.endEditing(true)
        agePicker.hidden = false
        DoneView.hidden = false
    }
    
    @IBAction func profileBtn(sender: AnyObject)
    {
        self.view.endEditing(true)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }

    // MARK: ImagePicker Delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            if update == "UPDATE"
            {
                //profile_updatePic.contentMode = .ScaleToFill
                profile_updatePic.image = pickedImage
                imag = 1
            }
            else
            {
                profilePicture.contentMode = .ScaleToFill
                profilePicture.setImage(pickedImage, forState: .Normal)
            }
           
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }    

    //MARK: registration method
    @IBAction func submitBtn(sender: AnyObject)
    {
        
    if ReachabilityNet.isConnectedToNetwork() == true
    {
      print("Internet connection OK")
        if update == "UPDATE"
        {
            if fullName.text == "" || emailFld.text == "" || userNameFld.text == "" || passwordFld.text == "" || genderFld.text == "" || locFld.text == "" || ageFld.text == "" || tagLineFld.text == "" || statusFld.text == ""
            {
                self.alertShowMethod("", message: "Please fill all fields")
            }
            else
            {
              
                //To save image
                var data1: NSData = NSData()
                if let image = self.profile_updatePic.image
                {
                    data1 = UIImageJPEGRepresentation(image,0.0)!
                }
                let base64String = data1.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                
                let data =
                    [
                        "fullname":self.fullName.text!,
                        "age":self.ageFld.text!,
                        "password":self.passwordFld.text!,
                        "location":self.locFld.text!,
                        "location_id":selectedLocationId,
                        "distance":self.distanceLbl.text!,
                        "status":self.statusFld.text!,
                        "tagline":self.tagLineFld.text!,
                        ]
                
                let users = ref.child("USERS")
                let current_user = users.child(user_ID!)
                current_user.updateChildValues(data)
                
                let images = ref.child("IMAGES")
                let node = images.child(user_ID!)
                node.updateChildValues(["profile_pic":base64String])
                
                self.alertShowMethod("", message: "Your profile is updated")
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }
        else
        {
            print("Sign Up btn is clicked")
            if fullName.text == "" || emailFld.text == "" || userNameFld.text == "" || passwordFld.text == "" || genderFld.text == "" || locFld.text == "" || ageFld.text == "" || tagLineFld.text == "" || statusFld.text == ""
            {
                self.alertShowMethod("", message: "Please fill all fields")
            }
            else if profilePicture.currentImage == UIImage(named:"uploadpic")
            {
                self.alertShowMethod("", message: "Please Select profile picture")
            }
                
            else
            {
                FIRAuth.auth()?.createUserWithEmail(emailFld.text!, password: passwordFld.text!) { (user, error) in
                    
                    if error == nil
                    {
                        
                            
                            //To save image
                            var data1: NSData = NSData()
                            if let image = self.profilePicture.currentImage
                            {
                                data1 = UIImageJPEGRepresentation(image,0.0)!
                            }
                            let base64String = data1.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                            
                            
                            // uid is the unique id of user
                            let uid = user!.uid
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(uid, forKey: "current_userID")
                            
                            print(NSUserDefaults.standardUserDefaults().objectForKey("current_userID"))
                            let users = self.ref.child("USERS")
                            let newUser = users.child(uid)
                            let user_cast = self.ref.child("USERCAST")
                            let usr_cast = user_cast.child(uid)
                        
                            let data =
                                [
                                    "fullname":self.fullName.text!,
                                    "username":self.userNameFld.text!,
                                    "gender":self.genderFld.text!,
                                    "age":self.ageFld.text!,
                                    "email":self.emailFld.text!,
                                    "password":self.passwordFld.text!,
                                    "location":self.locFld.text!,
                                    "location_id":selectedLocationId,
                                    "distance":self.distanceLbl.text!,
                                    "status":self.statusFld.text!,
                                    "tagline":self.tagLineFld.text!,
                                    "usercast":self.USER!,
                                    ]
                            
                            
                            let images = self.ref.child("IMAGES")
                            let node = images.child(uid)
                            node.setValue(["profile_pic":base64String])
                            
                            let data2 = [ "usercast" : self.USER!]
                            usr_cast.setValue(data2)
                            newUser.setValue(data)
                            print("Successfully created user account with uid: \(uid)")
                            
                            if self.USER == "HOST"
                            {
                                let hostVC = (self.storyboard!.instantiateViewControllerWithIdentifier("HostVC")) as! HostVC
                                hostVC.user_id = uid
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(uid, forKey: "current_userID")
                                defaults.setObject(self.emailFld.text, forKey: "email")
                                defaults.setObject(self.passwordFld.text, forKey: "password")
                                defaults.setObject(self.USER, forKey: "user_cast")
                                self.navigationController?.pushViewController(hostVC, animated: true)
                            }
                            else if self.USER == "SEEKER"
                            {
                                let seek = (self.storyboard!.instantiateViewControllerWithIdentifier("SeekVC")) as! SeekVC
                                seek.user_id = uid
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(uid, forKey: "current_userID")
                                defaults.setObject(self.emailFld.text, forKey: "email")
                                defaults.setObject(self.passwordFld.text, forKey: "password")
                                defaults.setObject(self.USER, forKey: "user_cast")
                                self.navigationController?.pushViewController(seek, animated: true)
                            }
                            self.alertShowMethod("", message: "Registration successfully done")
                            
                        
                    }
                    else
                    {
                        self.alertShowMethod("", message: "The specified email address is already in use")
                        // There was an error creating the account
                        print(error);
                    }
                }
//                ref.createUser(emailFld.text!, password: passwordFld.text!,
//                               withValueCompletionBlock:
//                    { error, result in
//                        if error != nil
//                        {
//                            self.alertShowMethod("", message: "The specified email address is already in use")
//                            // There was an error creating the account
//                            print(error);
//                        }
//                        else
//                        {
//                            
//                            //To save image
//                            var data1: NSData = NSData()
//                            if let image = self.profilePicture.currentImage
//                            {
//                                data1 = UIImageJPEGRepresentation(image,0.0)!
//                            }
//                            let base64String = data1.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
//                            
//                            
//                            // uid is the unique id of user
//                            let uid = result["uid"] as? String
//                            
//                            let defaults = NSUserDefaults.standardUserDefaults()
//                            defaults.setObject(uid, forKey: "current_userID")
//                            
//                        print(NSUserDefaults.standardUserDefaults().objectForKey("current_userID"))
//                            let users = ref.child("USERS")
//                            let newUser = users.child(uid)
//                            let usr_cast = self.user_cast.child(uid)
//                            
//                            let data =
//                                [
//                                    "fullname":self.fullName.text!,
//                                    "username":self.userNameFld.text!,
//                                    "gender":self.genderFld.text!,
//                                    "age":self.ageFld.text!,
//                                    "email":self.emailFld.text!,
//                                    "password":self.passwordFld.text!,
//                                    "location":self.locFld.text!,
//                                    "location_id":selectedLocationId,
//                                    "distance":self.distanceLbl.text!,
//                                    "status":self.statusFld.text!,
//                                    "tagline":self.tagLineFld.text!,
//                                    "usercast":self.USER!,
//                            ]
//                            
//                            
//                            
//                            let node = self.images.child(uid)
//                            node.setValue(["profile_pic":base64String])
//                            
//                            let data2 = [ "usercast" : self.USER!]
//                            usr_cast.setValue(data2)
//                            newUser.setValue(data)
//                            print("Successfully created user account with uid: \(uid)")
//                            
//                            if self.USER == "HOST"
//                            {
//                                let hostVC = (self.storyboard!.instantiateViewControllerWithIdentifier("HostVC")) as! HostVC
//                                hostVC.user_id = uid
//                                let defaults = NSUserDefaults.standardUserDefaults()
//                                defaults.setObject(uid, forKey: "current_userID")
//                                defaults.setObject(self.emailFld.text, forKey: "email")
//                                defaults.setObject(self.passwordFld.text, forKey: "password")
//                                defaults.setObject(self.USER, forKey: "user_cast")
//                                self.navigationController?.pushViewController(hostVC, animated: true)
//                            }
//                            else if self.USER == "SEEKER"
//                            {
//                                let seek = (self.storyboard!.instantiateViewControllerWithIdentifier("SeekVC")) as! SeekVC
//                                seek.user_id = uid
//                                let defaults = NSUserDefaults.standardUserDefaults()
//                                defaults.setObject(uid, forKey: "current_userID")
//                                defaults.setObject(self.emailFld.text, forKey: "email")
//                                defaults.setObject(self.passwordFld.text, forKey: "password")
//                                defaults.setObject(self.USER, forKey: "user_cast")
//                                self.navigationController?.pushViewController(seek, animated: true)
//                            }
//                            self.alertShowMethod("", message: "Registration successfully done")
//                            
//                        }
//                })
                
                
            }
            
 
        }
    }
    else
    {
       self.alertShowMethod("Internet connection error", message: "Plese try again")
    }
        
}
    

    
    //MARK: textField  delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
        
        if textField == locFld
        {
            let presentSearchVC = (self.storyboard!.instantiateViewControllerWithIdentifier("PresentSerachViewController")) as UIViewController
            
            self.presentViewController(presentSearchVC, animated: true, completion: nil)
        }
    }


    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        if textField.text == ""
        {
          // self.alertShowMethod("", message: "This field is Mendatory")
        }
        else if textField == userNameFld
        {
            
            let str = textField.text! as NSString
            if str.length < 3
            {
                print("Username must be 3 characters length")
                self.alertShowMethod("", message: "Username must be 3 characters length")
                return false
            }
            else
            {
                isExistUserName(str as String)
                boolvalue = true
            }

            
        }
        else if textField == passwordFld
        {
            let str = textField.text! as NSString
            if str.length < 6
            {
                self.alertShowMethod("", message: "Minimum 6 characters required")
                
                return false
                
            }
        }
        else if textField == emailFld
        {
            let str = textField.text! as NSString
            
            if isValidEmail(str as String)
            {
                print("it is valid email")
            }
            else
            {
                self.alertShowMethod("", message: "Enter a valid email id")
            }

        }
        
        return true
    }
    
    
    
    
    //MARK: to check exist User or not
    func isExistUserName(testUserName:String) -> Void
    {
//        print(self.ref.authData.uid)
//        
//        users.observeEventType(.Value, withBlock:
//            {
//                snapshot in
//
//                    print(snapshot.value.count)
//                    
//                    
//                    self.dict = snapshot.value as? NSDictionary
//                    print(self.dict)
//                    
//                    let all_user:NSArray =  self.dict!.allKeys
//                    
//                    for i in 0 ..< Int(all_user.count)
//                    {
//                        print(self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey("username"))
//                        
//                        let usr = self.dict!.objectForKey(all_user.objectAtIndex(i))?.objectForKey("username") as! String
//                        
//                        if usr == testUserName && self.boolvalue == true
//                        {
//                            self.boolvalue = false
//                            
//                            print("user exist")
//                            self.isExist = "Exist"
//                            print("user exist")
//                            self.alertShowMethod("Username", message: "already taken another user")
//                            self.userNameFld.text = ""
//                            
//                            self.textFieldShouldEndEditing(self.userNameFld)
//                            //self.userNameFld.delegate = self
//                            break
//                        }
//                        
//                    }
//            
//        })
//
// 
        
    }
    
    
    
    //MARK: to check valid email
    func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    //MARK:  api function for autocomplete for places
    func apiFunction(typpedStr: String)
    {

        var mutString = NSString(string: typpedStr)
        
        mutString = mutString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + (mutString as String) + "&types=(cities)&language=en&key=%20AIzaSyAqRxlbGhWi8TgHda6K23JRcTJciPmkBBc")
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
       
        task.resume()
        
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


