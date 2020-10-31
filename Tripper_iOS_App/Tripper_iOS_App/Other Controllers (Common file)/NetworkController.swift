//
//  NetworkController.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/24.
//

import Foundation

//建立共用連線資料
class NetworkController {
    
    let baseURL = URL(string: "http://localhost:8080/Tripper_JAVA_Web/")!
    
    static let shared = NetworkController()
    
    //創建流水編號ID
    static func getTransId () -> String {
        let date = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyyMMddHHmmssss"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")

        let dateString = dateFormatter.string(from: date)
        //print("TransId: \(dateString)")
        
        return dateString
    }
    
    
    
    func login (){
        let url = baseURL.appendingPathComponent("MemberServlet")
        
        
    }
    
    func register(){
        
    }
    
    func fetchImage(){
        
    }
    
    func fetchLocationInfo(){
        
    }
    
    
}
