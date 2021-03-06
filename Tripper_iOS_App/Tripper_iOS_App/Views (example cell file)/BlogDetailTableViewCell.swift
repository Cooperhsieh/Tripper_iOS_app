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
    lazy var tap: UITapGestureRecognizer =  {
        return UITapGestureRecognizer(target: self, action: #selector(tapOnImageView))
    }()
    lazy var tap2: UITapGestureRecognizer =  {
        return UITapGestureRecognizer(target: self, action: #selector(tapOnImageView2))
    }()
    lazy var tap3: UITapGestureRecognizer =  {
        return UITapGestureRecognizer(target: self, action: #selector(tapOnImageView3))
    }()
    lazy var tap4: UITapGestureRecognizer =  {
        return UITapGestureRecognizer(target: self, action: #selector(tapOnImageView4))
    }()
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
        pic1ImageView.addGestureRecognizer(tap)
        pic2ImageView.addGestureRecognizer(tap2)
        pic3ImageView.addGestureRecognizer(tap3)
        pic4ImageView.addGestureRecognizer(tap4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func tapOnImageView(sender: UIImageView) {
        EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: pic1ImageView, alpha: 1)
    }
    @objc func tapOnImageView2(sender: UIImageView) {
        EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: pic2ImageView, alpha: 1)
    }
    @objc func tapOnImageView3(sender: UIImageView) {
        EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: pic3ImageView, alpha: 1)
    }
    @objc func tapOnImageView4(sender: UIImageView) {
        EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: pic4ImageView, alpha: 1)
    }

}
