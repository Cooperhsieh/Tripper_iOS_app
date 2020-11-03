//
//  LocationListTableViewController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/31.
//

import UIKit

class LocationListTableViewController: UITableViewController, UISearchBarDelegate {
    
    var locInfo = [Location]()
    let url = URL(string: baseURL + "/LocationServlet")
    
    @IBOutlet var locationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
        searchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLocation()
    }
    
    /** tableView加上下拉更新功能 */
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchLocation), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    
    
    
    
    
    //建立SearchBar 元件
    func searchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.showsCancelButton = true
        
        searchBar.delegate = self
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.placeholder = "搜尋城市"
        locationTableView.tableHeaderView = searchBar
    }
    
    //執行搜索功能
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        if text == "" {
            fetchLocation()
        } else {
            locInfo = locInfo.filter({ (location) -> Bool in
                return location.city.contains(text)
            })
            
        }
        self.tableView.reloadData()
        
    }
    
    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.tintColor = .blue
        view.endEditing(true)
    }
    
    //抓取後台景點資料
    @objc func fetchLocation () {
        let requestParam = ["action" : "getAll"]
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    //print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Location].self, from: data!) {
                        self.locInfo = result
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
        return locInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDetailTableViewCell", for: indexPath) as! LocationDetailTableViewCell

        let locaitonList = locInfo[indexPath.row]
        
        //取得圖片
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = locaitonList.locId
        // 這邊圖片寬度不用寫 因為已在 Storyboard中的image設置 fill aspect
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {cell.LocImageView.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        cell.LocName.text = locaitonList.name
        cell.LocCity.text = locaitonList.city
        
        return cell
    }
    
    
    //左滑 編輯 or 刪除
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 左滑時顯示Edit按鈕
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, bool) in
            let updateLocation = self.storyboard?.instantiateViewController(identifier: "UpdateLocationUITableViewController") as! UpdateLocationTableViewController
            let location = self.locInfo[indexPath.row]
            updateLocation.locations = location
            self.navigationController?.pushViewController(updateLocation, animated: true)
        }
        edit.backgroundColor = UIColor.lightGray
        
        // 左滑時顯示Delete按鈕
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
            var requestParam = [String: Any]()
            requestParam["action"] = "locationDelete"
            requestParam["id"] = self.locInfo[indexPath.row].locId
            executeTask(self.url!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    self.locInfo.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .automatic)
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
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
    
    
    //第二頁 按下新增之後 可新增一筆資料
    @IBAction func unwindToLocationListTableViewController(Segue: UIStoryboardSegue) {
        guard Segue.identifier == "AddNewLoc" else {return}
        
        if let sourceViewController = Segue.source as? AddNewLocationViewController,
           let location = sourceViewController.locations {
            //新增回來至頂端第一筆
            locInfo.insert(location, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            
        }
    }

    
    // MARK: - Navigation
    //帶資料去下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let location = locInfo[indexPath.row]
            let contorller = segue.destination as! LocationDetailTableViewController
            contorller.locationDetail = location
        }
    }

}
