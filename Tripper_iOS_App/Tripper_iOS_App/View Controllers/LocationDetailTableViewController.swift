//
//  LocationDetailTableViewController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/11/3.
//

import UIKit

class LocationDetailTableViewController: UITableViewController {
    
    var locationDetail: Location!
    let url = URL(string: baseURL + "/LocationServlet")
    
    
    @IBOutlet weak var locIdLabel: UILabel!
    @IBOutlet weak var locNameLabel: UITextField!
    @IBOutlet weak var locAddressLabel: UITextField!
    @IBOutlet weak var locCityLabel: UITextField!
    @IBOutlet weak var locLongitudeLabel: UITextField!
    @IBOutlet weak var locLatitudeLabel: UITextField!
    @IBOutlet weak var locInfoLabel: UITextView!
    
    @IBOutlet weak var locImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let locInfo = locationDetail {
            locIdLabel.text = locInfo.locId
            locNameLabel.text = locInfo.name
            locAddressLabel.text = locInfo.address
            locCityLabel.text = locInfo.city
            locLongitudeLabel.text = String(locInfo.longitude)
            locLatitudeLabel.text = String(locInfo.latitude)
            locInfoLabel.text = locInfo.info
            fetchLocImage()
        }
        
        
    }
    
    
    // 利用loc ID去server端取對應照片
    func fetchLocImage () {
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = locationDetail.locId
        // 圖片寬度 = 螢幕寬度的
        requestParam["imageSize"] = view.frame.width
        executeTask(url!, requestParam) { (data, response, error) in
            var image: UIImage?
            if data != nil {
                image = UIImage(data: data!)
            }
            if image == nil {
                image = UIImage(named: "noImage.jpg")
            }
            DispatchQueue.main.async { self.locImageView.image = image }
        }
    }
    
    //按下鍵盤的return可收回鍵盤，詳情看右邊屬性欄的圓點 connection
    @IBAction func keyboardReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    
    
}
