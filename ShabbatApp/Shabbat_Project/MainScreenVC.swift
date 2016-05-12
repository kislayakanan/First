//
//  ViewController.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/18/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController
{
//app id  828137423996637
//app secreat 7fd6ad613b49d37598c0fb52400001af
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()        
        
       // navigationController!.navigationBar.
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        nav1Lbl.text = "Home"
        nav1Lbl.font = UIFont(name: "Helvetica-Bold", size: 19)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl      
    }

    override func viewWillAppear(animated: Bool)
    {
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
    }
    
    
    func backMethod()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func hostBtnAction(sender: AnyObject)
    {
        let hostVC = (self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")) as! LoginViewController
        hostVC.USER="HOST"
        self.navigationController?.pushViewController(hostVC, animated: true)
    }
    
    @IBAction func seekBtnAction(sender: AnyObject)
    {
        let seekLogin = (self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")) as! LoginViewController
        seekLogin.USER="SEEKER"
        self.navigationController?.pushViewController(seekLogin, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

