//
//  MovieService.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void)
}

final class MovieService: MovieServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchPopularMovies(
        page: Int,
        completion: @escaping (Result<[Movie], Error>) -> Void
    ) {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        apiClient.performRequest(
            endpoint: "movie/popular",
            queryItems: queryItems
        ) { (result: Result<MovieResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetails(
        id: Int,
        completion: @escaping (Result<MovieDetails, Error>) -> Void
    ) {
        let queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        apiClient.performRequest(
            endpoint: "movie/\(id)",
            queryItems: queryItems,
            completion: completion
        )
    }
}
