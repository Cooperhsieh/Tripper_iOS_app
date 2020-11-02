//
//  Location.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/31.
//

import Foundation

struct Location: Codable {
    var locId: String
    var name: String
    var address: String
    var locType: String?
    var city: String
    var info: String
    var longitude: Double
    var latitude: Double

}



