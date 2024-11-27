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
    
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let endpoint = "movie/popular?page=\(page)"
        apiClient.performRequest(endpoint: endpoint, completion: completion)
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let endpoint = "movie/\(id)"
        apiClient.performRequest(endpoint: endpoint, completion: completion)
    }
}
