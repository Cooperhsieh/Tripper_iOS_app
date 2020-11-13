//
//  AddNewLocationViewController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/11/2.
//

import UIKit


class AddNewLocationViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var longtitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    var locations: Location?
    var image: UIImage?
    let url = URL(string: baseURL + "/LocationServlet")

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    //照片選取
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let locImage = info[.originalImage] as? UIImage
        image = locImage
        imageView.image = locImage
        dismiss(animated: true, completion: nil)
    }
    
    //新增照片按鈕
    @IBAction func addLocPic(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    //按下建立行程按鈕，回到第一頁的 List unwindSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "AddNewLoc" else {return}
            
        let name = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let longtitude = Double(longtitudeTextField.text ?? "") ?? 0
        let latitude = Double(latitudeTextField.text ?? "") ?? 0
        let info = infoTextView.text ?? ""
        
        let location = Location(locId: getTransId(), name: name, address: address, city: city, info: info, longitude: longtitude, latitude: latitude)
        
        var requestParam = [String: String]()
        requestParam["action"] = "locationInsert"
        requestParam["location"] = try! String(data: JSONEncoder().encode(location), encoding: .utf8)
        // 有圖才上傳
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(self.url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result){
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    print("成功比數： \(count)")
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
}

