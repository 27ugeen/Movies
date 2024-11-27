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
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let genreIds: [Int]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case genreIds = "genre_ids"
    }
}
