//
//  MovieDetails.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

struct MovieDetails: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let genres: [Genre]
    let voteAverage: Double
    let runtime: Int?
    let posterPath: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case genres
        case voteAverage = "vote_average"
        case runtime
        case posterPath = "poster_path"
    }
}
