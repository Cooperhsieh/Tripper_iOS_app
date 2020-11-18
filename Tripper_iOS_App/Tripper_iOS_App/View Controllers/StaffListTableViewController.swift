//
//  StaffListTableViewController.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/10.
//

import UIKit

class StaffListTableViewController: UITableViewController {

    var members = [Member]()
    let url = URL(string: baseURL + "/ManagerServlet")
    let userDefault = UserDefaults.standard
    var status = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1)
        status = userDefault.integer(forKey: "STATUS")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchMembers), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMembers()
    }
    
    @objc func fetchMembers(){
        let requestParam = ["action" : "getManagerList"]
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    
                    if let result = try? JSONDecoder().decode([Member].self, from: data!) {
                        self.members = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    // 停止下拉更新動作
                                    control.endRefreshing()
                                }
                            }
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StaffListTableViewCell.self)", for: indexPath) as! StaffListTableViewCell

        let member = members[indexPath.row]
        
        cell.nameLabel.text = member.nickName
        cell.idLabel.text = "員工編號：\(member.id)"
        cell.accountLabel.text = "帳號：\(member.account)"
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if status == 1 { // 左滑時顯示Delete按鈕
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
            var requestParam = [String: Any]()
            requestParam["action"] = "deleteManager"
            requestParam["managerId"] = self.members[indexPath.row].id
            executeTask(self.url!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    self.members.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .automatic)
                                        let controller = UIAlertController(title: "後台帳號管理", message: "已將此帳號刪除", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "ok", style: .default)
                                          controller.addAction(okAction)
                                        self.present(controller, animated: true, completion: nil)
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
        delete.backgroundColor = UIColor.red
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
            
        return swipeActions
        }else {
            return nil
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logOut(_ sender: Any) {
        let controller = UIAlertController(title: "登出", message: "確定登出嗎？", preferredStyle: .alert)
        let logOut = UIAlertAction(title: "登出", style: .default) {
            (_) in self.navigationController?.popToRootViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (alertAction) in
        }
        controller.addAction(logOut)
        controller.addAction(cancel)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func log(_ sender: Any) {
        userDefault.setValue("login", forKey: "OFF")
    }
    
    
    
}
