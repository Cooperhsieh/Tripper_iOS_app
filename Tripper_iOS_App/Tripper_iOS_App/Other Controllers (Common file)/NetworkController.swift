//
//  NetworkController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/24.
//

import Foundation
import UIKit


let baseURL = "http://localhost:8080/Tripper_JAVA_Web/"

//建立共用連線資料
func executeTask(_ url: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

//創建流水編號ID
func getTransId () -> String {
    let date = Date()
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyyMMddHHmmssss"
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")

    let dateString = dateFormatter.string(from: date)
    //print("TransId: \(dateString)")
    
    return dateString
}




