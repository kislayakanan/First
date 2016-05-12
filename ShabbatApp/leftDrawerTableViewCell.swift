//
//  leftDrawerTableViewCell.swift
//  Shabbat_Project
//
//  Created by webastral on 5/7/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit

class leftDrawerTableViewCell: UITableViewCell
{
   
    @IBOutlet var cellImageView: UIImageView!
   
    @IBOutlet var cellLabel: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
