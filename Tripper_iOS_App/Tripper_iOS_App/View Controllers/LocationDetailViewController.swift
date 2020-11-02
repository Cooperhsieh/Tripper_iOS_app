//
//  LocationDetailViewController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/31.
//

import UIKit


class LocationDetailViewController: UIViewController {
    
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
    
    @IBOutlet weak var LocInfoTextView: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
       addKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locInfo = locationDetail {
            locIdLabel.text = locInfo.locId
            locNameLabel.text = locInfo.name
            locAddressLabel.text = locInfo.address
            locCityLabel.text = locInfo.city
            locLongitudeLabel.text = String(locInfo.longitude)
            locLatitudeLabel.text = String(locInfo.latitude)
            LocInfoTextView.text = locInfo.info
            fetchLocImage()
        }
    }
    
    // 利用spot ID去server端取對應照片
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
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//調整鍵盤高度
extension LocationDetailViewController {
    func addKeyboardObserver() {
        //name = 想要
        //object = 想要發送給的物件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        //userinfo? = 有可能是空值 官方的資料
        //keyboardFrameEndUserInfoKey = 取得官方資料，[]裡面是Dictionary
        //as? NSValue = 轉成NSValue 有可能是空值，所以用if let
        //keyboardFrame.cgRectValue 鍵盤外框尺寸
        //keyboardRect.height 虛擬鍵盤高度
        //view = 繼承了 UIViewController 直接用
        //origin = 原點的y座標 = 00
        //-keyboardHeight 原點的位置往上移動300，向上為負
        
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight
        } else { //取得螢幕的框（frame）/3
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        //解除監聽用remove
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
