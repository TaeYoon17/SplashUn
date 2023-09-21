//
//  PunkItem.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import Foundation
// MARK: - PunkResponse
struct PunkResponse: Codable, Hashable {
    static func == (lhs: PunkResponse, rhs: PunkResponse) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    let id = UUID()
    let beerID: Int
    let name: String
    let description: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case beerID = "id"
        case name,description,imageURL = "image_url"
    }
}
