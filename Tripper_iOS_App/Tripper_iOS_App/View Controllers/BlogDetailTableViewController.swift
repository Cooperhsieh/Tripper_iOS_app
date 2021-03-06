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
    var imageView : UIImageView?
    var blogPicDic = [String: BlogPic]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let detail = blogDetail {
            blogId = detail.blogId
            titleLabel.text = detail.tittleName
            fetchHeaderImage(blogId: detail.blogId)
            
        }
        
        fetchBlogDetail()
        
    }

    @objc func fetchHeaderImage(blogId : String){
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = blogId
        requestParam["imageSize"] = self.view.frame.width
        
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let image = UIImage(data: data!){
                        DispatchQueue.main.async {
                            self.headerImageView.image = image
                           
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.headerImageView.image = UIImage(named: "noImage.jpg")
                    }
                }
               
            } else {
                print(error!.localizedDescription)
            }
        }
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
        
    
        
        cell.task?.cancel()
        
        let blog = blogDetailList[indexPath.row]
        cell.spotNameLabel.text = blog.locationName
        cell.dateLabel.text = blog.s_Date
        if let blogInfo = blog.blogNote {
            print(blogInfo)
            cell.spotInfoLabel.text = "文字敘述：\n\(blogInfo)"
        }else{
            cell.spotInfoLabel.text = "無文字說明"
        }

  
        var requestParam = [String: Any]()
        requestParam["action"] = "getSpotImage"
        requestParam["blog_Id"] = blog.blogId
        requestParam["loc_Id"] = blog.locationId
        
        cell.pic1ImageView.isHidden = true
        cell.pic2ImageView.isHidden = true
        cell.pic3ImageView.isHidden = true
        cell.pic4ImageView.isHidden = true
//

        print("blogId",blog.blogId,"locationId",  blog.locationId, indexPath)
        cell.task = executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    //print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode(BlogPic.self, from: data!) {
                       let blogPic = result
                        
                        print("result", blog.locationId, indexPath, self.blogPic?.pic1?.count)
                        
                        

                        DispatchQueue.main.async {
                            
                            if let pic1 = blogPic.pic1 {
                                print("indexPath pic1", indexPath)

                                let decodedData = NSData(base64Encoded : pic1, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!

                                    cell.pic1ImageView.image = decodedimage
                                    cell.pic1ImageView.isHidden = false
                                print("#############111111")
                            }else {
                                cell.pic1ImageView.isHidden = false
                                cell.pic1ImageView.image =  UIImage(named: "nopic")
                            }

                            if let pic2 = blogPic.pic2 {
                                let decodedData = NSData(base64Encoded : pic2, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!

                                cell.pic2ImageView.image = decodedimage
                                cell.pic2ImageView.isHidden = false
                                print("#############22222")
                            }else {
                                cell.pic2ImageView.isHidden = true
                            }

                            if let pic3 = blogPic.pic3 {
                                let decodedData = NSData(base64Encoded : pic3, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!
                                cell.pic3ImageView.image = decodedimage
                                cell.pic3ImageView.isHidden = false
                                print("#############333333")
                            }else{
                                cell.pic3ImageView.isHidden = true
                            }


                            if let pic4 = blogPic.pic4 {
                                let decodedData = NSData(base64Encoded : pic4, options: NSData.Base64DecodingOptions())
                                let decodedimage = UIImage(data: decodedData! as Data)!
                                cell.pic4ImageView.image = decodedimage
                                cell.pic4ImageView.isHidden = false
                                print("#############44444444")
                            }else {
                                cell.pic4ImageView.isHidden = true

                            }
//
//
                       }
//
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
            
        }
//        imageView = cell.pic1ImageView
        return cell
    }
    
//    @objc private func tapOnImageView() {
//        EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: pic1ImageView, alpha: 1)
//    }

   
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
