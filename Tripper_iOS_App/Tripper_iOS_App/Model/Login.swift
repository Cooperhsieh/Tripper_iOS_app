//
//  Login.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/31.
//

import Foundation

struct LoginPost: Encodable {
    let action = "getProfile"
    let account: String
}

struct Member: Codable {
    let id: Int
    let account: String
    let password: String
    let nickName: String
    let loginType: Int
}
