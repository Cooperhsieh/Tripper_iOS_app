//
//  AddNewLocationTableViewController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/11/3.
//

import UIKit

class AddNewLocationTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var longtitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var magicButton: UIButton!
    
    
    
    
    var locations: Location?
    var image: UIImage?
    let url = URL(string: baseURL + "/LocationServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1)
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
    
    
    //鍵盤收回
    @IBAction func keyboardReturnPressed(_ sender: Any) {
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "AddNewLoc" else {return}
            
        let name = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let longtitude = Double(longtitudeTextField.text ?? "") ?? 0
        let latitude = Double(latitudeTextField.text ?? "") ?? 0
        let info = infoTextView.text ?? ""
        
        let location = Location(locId: getTransId(), name: name, address: address,  city: city, info: info, longitude: longtitude, latitude: latitude)
        
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
    
    @IBAction func magicButton(_ sender: Any) {
        nameTextField.text = "雙心石滬"
        addressTextField.text = "883 澎湖縣七美鄉"
        cityTextField.text = "澎湖縣"
        longtitudeTextField.text = "119.44577"
        latitudeTextField.text = "23.219828"
        infoTextView.text = "石滬是在潮間帶區域堆砌弧形石牆，利用海水漲潮時會淹覆石牆頂部並且帶來魚群，退潮時海水流走而魚群便會困在石牆內的一種捕魚陷阱，澎湖的石滬極可能是全世界密度最高、數量最多的地方。雙心石滬是目前保留最完整、造型最浪漫的石滬，若要觀看雙心石滬全貌，必須先確認每日的退潮時間，才能順利看到完整的雙心石滬。"
        
    }
    
    
    @IBAction func returnKeyBoard(_ sender: UITextField) {
        
    }
    
    
    
    
}
    



