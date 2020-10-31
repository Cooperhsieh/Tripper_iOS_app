//
//  Location.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/31.
//

import Foundation

struct LocationPost: Encodable {
    let action = "locationInsert"
    let locationInfo: Location
}



struct Location: Codable {
    let locId: String
    let name: String
    let address: String
    let locType: String?
    let city: String
    let info: String
    let longitude: Double
    let latitude: Double
    //let loc_Pic:
}
