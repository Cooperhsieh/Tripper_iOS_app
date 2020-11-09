//
//  LoginViewController.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/4.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginInfoLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var member : aAndP?
    let url = URL(string: baseURL + "/MemberServlet")
    var isAccess : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    func authentication(account : String , password : String){
        member = aAndP(account: account, password: password)
        var requestParam = [String : String]()
        requestParam["action"] = "managerlogIn"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        
        executeTask(self.url!, requestParam) { (data, reponse, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8){
                        if let count = Int(result){
                            DispatchQueue.main.async {
                                if count == 1 {
                    self.performSegue(withIdentifier: "login", sender: self)
                                } else {
                                        self.loginInfoLabel.text = "帳號或密碼錯誤"
                                    }
                                }
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func login(_ sender: Any) {
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if account == "" || password == "" {
            loginInfoLabel.text = "欄位不得為空值"
        }else{
            authentication(account: account, password: password)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        
    }
    
    @IBAction func unwindSegueToLoginViewController(segue: UIStoryboardSegue) {
       
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
