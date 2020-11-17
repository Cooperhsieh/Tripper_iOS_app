//
//  BlogTableViewController.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/13.
//

import UIKit

class BlogTableViewController: UITableViewController {
    
    var blogList = [Explore]()
    let url = URL(string: baseURL + "/ExploreServlet")
    let blogUrl = URL(string: baseURL + "/BlogServlet")
    let memberUrl = URL(string: baseURL + "/MemberServlet")
    
    @IBOutlet var blogTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBlog()
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchBlog), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func fetchBlog() {
        let requestParam = ["action" : "getAll"]
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    //print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Explore].self, from: data!) {
                        self.blogList = result
                        
                        DispatchQueue.main.async {
                            
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
                            print("@@\(self.blogList)")
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blogList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(BlogTableViewCell.self)", for: indexPath) as! BlogTableViewCell
        
        let blog = blogList[indexPath.row]
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = blog.blogId
        requestParam["imageSize"] = cell.frame.width
        
        var userrequestParam = [String: Any]()
        userrequestParam["action"] = "getImage"
        userrequestParam["id"] = blog.userId
        userrequestParam["imageSize"] = cell.frame.width
        
        var image: UIImage?
        var userImage : UIImage?
        executeTask(blogUrl!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let image = UIImage(data: data!){
                        DispatchQueue.main.async {
                            cell.blogImageView.image = image
                        }
                    }
                }
                else {
                    image = UIImage(named: "noImage.jpg")
                    DispatchQueue.main.async {
                        cell.blogImageView.image = image
                    }
                }
               
            } else {
                print(error!.localizedDescription)
            }
        }
        //抓取大頭貼
        
        executeTask(memberUrl!, userrequestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let userImage = UIImage(data: data!){
                        DispatchQueue.main.async {
                            cell.userPicImageView.image = userImage
                        }
                    }
                }
                else {
                    userImage = UIImage(named: "noImage.jpg")
                    DispatchQueue.main.async {
                        cell.userPicImageView.image = userImage
                    }
                }
                
            } else {
                print(error!.localizedDescription)
            }
        }
        cell.blogNameLabel.text = blog.tittleName
        cell.userNameLabel.text = blog.nickName
        cell.dateLabel.text = "上傳日期：\(blog.dateTime)"
        
        return cell
    }
    
    //左滑 編輯 or 刪除
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        // 左滑時顯示Edit按鈕
//        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, bool) in
//            let updateLocation = self.storyboard?.instantiateViewController(identifier: "UpdateLocationUITableViewController") as! UpdateLocationTableViewController
//            let blog = self.blogList[indexPath.row]
//            updateLocation.locations = location
//            self.navigationController?.pushViewController(updateLocation, animated: true)
//        }
//        edit.backgroundColor = UIColor.lightGray
        
        // 左滑時顯示Delete按鈕
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
            var requestParam = [String: Any]()
            requestParam["action"] = "blogDelete"
            requestParam["blogId"] =  self.blogList[indexPath.row].blogId
            let blogId = self.blogList[indexPath.row].blogId
            executeTask(self.blogUrl!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    self.blogList.remove(at: indexPath.row)
                                    self.tripDataChange(blogId: blogId)
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .automatic)
                                        let controller = UIAlertController(title: "Blog Manage", message: "已將此網誌下架！", preferredStyle: .alert)
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
    }
    
    func tripDataChange(blogId : String){
        var requestParam = [String: Any]()
        requestParam["action"] = "Trip_M_Servlet"
        requestParam["tripId"] = blogId
        requestParam["blogStatus"] = 0
        executeTask(self.url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            // 確定server端刪除資料後，才將client端資料刪除
                            if count != 0 {
                              print("更改成功")
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
    }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "blogDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let blog = blogList[indexPath.row]
            let contorller = segue.destination as! BlogDetailTableViewController
            contorller.blogDetail = blog
        }
    }
}
