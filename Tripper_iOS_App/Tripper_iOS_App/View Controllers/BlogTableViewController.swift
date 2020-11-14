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
    
    @IBOutlet var blogTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchBlog()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBlog()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blogList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogTableViewCell", for: indexPath) as! BlogTableViewCell
        
        let blog = blogList[indexPath.row]
        
//        var requestParam = [String: Any]()
//        requestParam["action"] = "getImage"
//        requestParam["id"] = blog.blogId
//        requestParam["imageSize"] = cell.frame.width
//        var image: UIImage?
//        executeTask(blogUrl!, requestParam) { (data, response, error) in
//            if error == nil {
//                if data != nil {
//                    image = UIImage(data: data!)
//                }
//                if image == nil {
//                    image = UIImage(named: "noImage.jpg")
//                }
//                DispatchQueue.main.async {
//                    cell.blogImageView.image = image
//                    print("############有成功執行")
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
        cell.blogNameLabel.text = blog.tittleName
        print("##############\(blog.tittleName)")
        return cell
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

}
