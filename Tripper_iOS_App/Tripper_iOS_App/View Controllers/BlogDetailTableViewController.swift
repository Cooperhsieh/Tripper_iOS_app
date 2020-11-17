//
//  BlogDetailTableViewController.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/14.
//

import UIKit

class BlogDetailTableViewController: UITableViewController {
    var blogDetail: Explore!
    var blogDetailList = [BlogD]()
    var blogId : String = ""
    let url = URL(string: baseURL + "/BlogServlet")
    var blogPic : BlogPic?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let detail = blogDetail {
            blogId = detail.blogId
        }
      
        fetchBlogDetail()
    }

    @objc func fetchBlogDetail(){
        var requestParam = [String: Any]()
        requestParam["action"] = "findById"
        requestParam["id"] = blogId
   
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
               
                if data != nil {
                    print("")
               
                    if let result = try? JSONDecoder().decode([BlogD].self, from: data!) {
                        self.blogDetailList = result
                        
                        DispatchQueue.main.async {
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
                            print("#############\(self.blogDetailList)")
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
        return blogDetailList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(BlogDetailTableViewCell.self)", for: indexPath) as! BlogDetailTableViewCell
        
        let blog = blogDetailList[indexPath.row]
        cell.spotNameLabel.text = blog.locationName
        cell.dateLabel.text = blog.s_Date
        if let blogInfo = blog.blogNote {
            cell.spotInfoLabel.text = "文字敘述：\(blogInfo)"
        }else{
            cell.spotInfoLabel.text = "文字敘述：無文字說明"
        }
        cell.pic1ImageView.image = nil
        cell.pic2ImageView.image = nil
        cell.pic3ImageView.image = nil
        cell.pic4ImageView.image = nil
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getSpotImage"
        requestParam["blog_Id"] = blog.blogId
        requestParam["loc_Id"] = blog.locationId
        
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    //print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode(BlogPic.self, from: data!) {
                        self.blogPic = result
                        
                        DispatchQueue.main.async {
                            
                            if let pic1 = self.blogPic?.pic1 {
                                let decodedData = NSData(base64Encoded : pic1, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!
                                cell.pic1ImageView.image = decodedimage
                            };if let pic2 = self.blogPic?.pic1 {
                                let decodedData = NSData(base64Encoded : pic2, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!
                                cell.pic2ImageView.image = decodedimage
                            };if let pic3 = self.blogPic?.pic1 {
                                let decodedData = NSData(base64Encoded : pic3, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!
                                cell.pic3ImageView.image = decodedimage
                            };if let pic4 = self.blogPic?.pic1 {
                                let decodedData = NSData(base64Encoded : pic4, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!
                                cell.pic4ImageView.image = decodedimage
                            }
                            
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        

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
