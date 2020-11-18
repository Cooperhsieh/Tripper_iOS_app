//
//  LocationDetailTableViewCell.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/31.
//

import UIKit

class LocationDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var LocImageView: UIImageView!
    @IBOutlet weak var LocName: UILabel!
    @IBOutlet weak var LocCity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
