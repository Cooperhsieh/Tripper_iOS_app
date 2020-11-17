//
//  LoginViewController.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/4.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var loginInfoLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var member : aAndP?
    let url = URL(string: baseURL + "/MemberServlet")
    var isAccess : Bool = false
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = false
        accountTextField.isSecureTextEntry = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
     
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == passwordTextField && !passwordTextField.isSecureTextEntry) {
            passwordTextField.isSecureTextEntry = true
        }
        
        return true
        }
    
    func authentication(account : String , password : String){
        member = aAndP(account: account, password: password)
        var requestParam = [String : String]()
        requestParam["action"] = "managerlogIn"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        
        executeTask(url!, requestParam) { (data, reponse, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8){
                        if let count = Int(result){
                            DispatchQueue.main.async {
                                if count == 0 || count == 1 {
                                    self.userDefault.set(count,forKey: "STATUS")
                                    self.accountTextField.text = ""
                                    self.passwordTextField.text = ""
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
//
//let userdefault = UserDefaults.standard
//userdefault.set(Int,forKey: "")
//
//let userDefault = UserDefaults.standard
//let name = userdefault.integer(forKey: <#T##String#>)
//
