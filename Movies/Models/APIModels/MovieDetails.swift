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
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let genres: [Genre]?
    let productionCountries: [String]?
    let video: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genres
        case productionCountries = "origin_country"
        case video
    }
}
