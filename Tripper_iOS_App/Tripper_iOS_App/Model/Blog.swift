//
//  Blog.swift
//  Tripper_iOS_App
//
//  Created by 蕭至廷 on 2020/11/13.
//

import Foundation



struct Explore : Codable {
    var blogId: String
    var userId: String
    var nickName : String
    var tittleName: String
    var blogDesc: String
    var dateTime: String
}

struct BlogD : Codable {

    var locationId : String
    var locationName : String
    var blogNote : String?
    var s_Date : String
    var blogId : String
    var tripId : String
}

struct BlogPic : Codable {
    var blogId : String?
    var locId : String?
    var pic1 : String?
    var pic2 : String?
    var pic3 : String?
    var pic4 : String?
}
