//
//  MovieVideo.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import Foundation

struct MovieVideo: Decodable {
    let name: String
    let key: String
    let site: String
    let type: String
    let official: Bool
    
    private enum CodingKeys: String, CodingKey {
        case name, key, site, type, official
    }
}

struct MovieVideosResponse: Decodable {
    let id: Int
    let results: [MovieVideo]
}
