//
//  BlogDetailTableViewCell.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/14.
//

import UIKit

class BlogDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var pointImageView: UIImageView!
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pic1ImageView: UIImageView!
    @IBOutlet weak var pic2ImageView: UIImageView!
    @IBOutlet weak var pic3ImageView: UIImageView!
    @IBOutlet weak var pic4ImageView: UIImageView!
    @IBOutlet weak var spotInfoLabel: UILabel!
    var blogId: String!
    
    var task: URLSessionTask?
//
    override func prepareForReuse() {
        super.prepareForReuse()
        pic1ImageView.image = nil
        pic2ImageView.image = nil
        pic3ImageView.image = nil
        pic4ImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
