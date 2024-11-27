//
//  Movie.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let genreIds: [Int]
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    let adult: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case overview
        case adult
    }
}
