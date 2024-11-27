//
//  Genre.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct GenreResponse: Decodable {
    let genres: [Genre]
}
