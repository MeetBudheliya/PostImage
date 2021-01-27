//
//  PostRegisterModel.swift
//  GetPostData
//
//  Created by MAC on 21/12/20.
//

import Foundation
struct RegisterModal:Codable{
    let name:String?
    let email:String?
    let phone:String?
    let password:String?
    let confirmPassword:String?
    enum CodingKeys:String,CodingKey{
        case name = "name"
        case email = "email"
        case phone = "phone"
        case password = "password"
        case confirmPassword = "confirmPassword"
    }

}
struct ErrorMessage: Codable {
    let status: String?
    let data: DataClass?
    let messages: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let name, email, phone: String?
    let id: Int?
}

