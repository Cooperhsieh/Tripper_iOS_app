//
//  RegisterViewController.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/6.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var magicButton: UIButton!
    
    
    
    var member : Member?
    let url = URL(string: baseURL + "/MemberServlet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        infoLabel.text = ""
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let password2 = password2TextField.text ?? ""
        let name = nameTextField.text ?? ""
        
        if(account == "" || password == "" || password2 == "" || name == ""){
            infoLabel.text = "欄位不得為空"
            return
        }
        
        if(password != password2){
            infoLabel.text = "密碼與確認密碼不符"
            return
        }
        
        if(name.count > 10){
            infoLabel.text = "名稱不得超過10字元"
            return
        }
        
        
        member = Member(id : 0 ,account : account , password : password , nickName : name)
        var requestParam = [String : String]()
        requestParam["action"] = "managerInsert"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        executeTask(self.url!, requestParam) { (data, reponse, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8){
                        if let count = Int(result){
                            DispatchQueue.main.async {
                                if count == 1 {
                                    
                                    let controller = UIAlertController(title: "註冊成功", message: "請重新登入", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default){
                                        (_) in self.performSegue(withIdentifier: "back", sender: nil)
                                    }
                                      controller.addAction(okAction)
                                    self.present(controller, animated: true, completion: nil)
                                    
                                } else {
                                    self.infoLabel.text = "註冊失敗，已有相同帳號"
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
    
    
    //按return 收回鍵盤
    @IBAction func returnKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    //神奇按鈕
    @IBAction func magicButton(_ sender: Any) {
        
        accountTextField.text = "Peter"
        passwordTextField.text = "passsword"
        password2TextField.text = "passsword"
        nameTextField.text = "Peter Pan"
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
