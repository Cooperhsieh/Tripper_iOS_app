//
//  UpdateLocationTableViewController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/11/3.
//

import UIKit

class UpdateLocationTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    @IBOutlet weak var locIdLabel: UILabel!
    @IBOutlet weak var locNameTextField: UITextField!
    @IBOutlet weak var locAddressTextField: UITextField!
    @IBOutlet weak var locCityTextField: UITextField!
    @IBOutlet weak var longtitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var locations: Location!
    let url = URL(string: baseURL + "/LocationServlet")
    var imageUpdate: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocInfo()
    }
    
    func fetchLocInfo () {
        locIdLabel.text = locations.locId
        locNameTextField.text = locations.name
        locAddressTextField.text = locations.address
        locCityTextField.text = locations.city
        longtitudeTextField.text = String(locations.longitude)
        latitudeTextField.text = String(locations.latitude)
        infoTextField.text = locations.info
        
        // 利用Loc ID去server端取對應照片
        var requestParam = [String : Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = locations.locId
        requestParam["imageSize"] = view.frame.width
        
        executeTask(self.url!, requestParam) { (data, response, error) in
            var image: UIImage?
            if data != nil {
                image = UIImage(data: data!)
            }
            if image == nil {
                image = UIImage(named: "noImage.jpg")
            }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let locImage = info[.originalImage] as? UIImage
        imageUpdate = locImage
        imageView.image = locImage
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeLocPic(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    
    //編輯景點按下後回到景點列表
    @IBAction func updateLocInfo(_ sender: Any) {
        locations.name = locNameTextField.text ?? ""
        locations.address = locAddressTextField.text ?? ""
        locations.city = locCityTextField.text ?? ""
        locations.longitude = Double(longtitudeTextField.text ?? "") ?? 0
        locations.latitude = Double(latitudeTextField.text ?? "") ?? 0
        locations.info = infoTextField.text ?? ""
        
        
        var requestParam = [String: String]()
        requestParam ["action"] = "locationUpdate"
        requestParam ["location"] = try! String(data: JSONEncoder().encode(self.locations), encoding: .utf8)
        
        if self.imageUpdate != nil {
            requestParam["imageBase64"] = self.imageUpdate!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        
        executeTask(self.url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    print("error")
                                }
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
                
            }
        }
        
    }
    
    
    @IBAction func keyboardReturnPressed(_ sender: Any) {
    }


}
