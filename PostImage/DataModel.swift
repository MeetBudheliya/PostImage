//
//  DataModel.swift
//  GetPostData
//
//  Created by MAC on 21/12/20.
//
import Foundation
struct MainData : Codable {
    let id : Int?
    let title : String?
    let description : String?
    let image : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case description = "description"
        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent([String].self, forKey: .image)
    }

}
