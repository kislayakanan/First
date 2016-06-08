//
//  PresentSerachViewController.swift
//  Shabbat_Project
//
//  Created by webastral on 21/05/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class PresentSerachViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var locTxtFeild: UITextField!
    //var filteredData = [String]()
    var placesArr: [AnyObject] = [AnyObject]()
    var myTextField: UITextField = UITextField() 
    @IBOutlet weak var clearFieldBtn: UIButton!
    @IBOutlet weak var placesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        placesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
       
            
            locTxtFeild.leftViewMode = .Always
            locTxtFeild.leftView = UIImageView(image: UIImage(named: "search"))
        locTxtFeild.leftView?.frame = CGRectMake(0, 0,20, 20)

        
        

    }
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        clearFieldBtn.clipsToBounds = true
        clearFieldBtn.layer.cornerRadius = 9.0
        clearFieldBtn.hidden = true
    }
    
    @IBAction func clearFeildBtnAction(sender: AnyObject)
    {
        locTxtFeild.text = ""
        //clearFieldBtn.hidden = true
       
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return placesArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        for object in cell.contentView.subviews
        {
            object.removeFromSuperview();
        }
        
        //Label in cell
        let label = UILabel(frame: CGRectMake(20, 0, cell.frame.size.width-40, cell.frame.size.height))
        label.text = placesArr[indexPath.row].objectForKey("Address") as? String
        label.font = UIFont(name: "Montserrat-Regular", size: 15)
        label.backgroundColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(label)

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print(placesArr);
        locTxtFeild.text = placesArr[indexPath.row].objectForKey("Address") as? String
        selectedLocationId = (placesArr[indexPath.row].objectForKey("Place_ID") as? String)!
        print(locTxtFeild.text!)
       selectedLocation = locTxtFeild.text!
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func edited()
    {
        
        self.apiFunction(locTxtFeild.text!)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
       

        if textField == locTxtFeild
         {
            clearFieldBtn.hidden = false
            locTxtFeild.addTarget(self, action:#selector(edited), forControlEvents:UIControlEvents.EditingChanged)
        }
    }
    
    
    func apiFunction(typpedStr: String)
    {
        
        var mutString = NSString(string: typpedStr)
        
        mutString = mutString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + (mutString as String) + "&types=address&language=en&key=%20AIzaSyAqRxlbGhWi8TgHda6K23JRcTJciPmkBBc")
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
                        dic1.setValue((arr.objectAtIndex(i).objectForKey("terms"))?.objectAtIndex(((arr.objectAtIndex(i).objectForKey("terms"))?.count)! - 2).objectForKey("value"), forKey: "City")
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


    @IBAction func cancelBtnAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
