//
//  BlogTableViewCell.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/13.
//

import UIKit

class BlogTableViewCell: UITableViewCell {

    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
