//
//  BlogTableViewCell.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/13.
//

import UIKit

class BlogTableViewCell: UITableViewCell {

    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blogNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
