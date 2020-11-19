//
//  AppMessage.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/19.
//

import Foundation

struct AppMessages : Codable {
    var msgType : String
    var memberId : Int
    var msgTitle : String
    var msgBody : String
    var msgStat : Int
    var sendId : Int
    var reciverId : Int
}
