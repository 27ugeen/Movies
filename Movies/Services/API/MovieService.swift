//
//  MovieService.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(page: Int, sortBy: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void)
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void)
}

final class MovieService: MovieServiceProtocol {
    private let apiClient: APIClientProtocol
    private var genresCache: [Int: String] = [:]
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchPopularMovies(page: Int, sortBy: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "sort_by", value: sortBy),
//            URLQueryItem(name: "include_video", value: "true")
        ]
        
        apiClient.performRequest(endpoint: "discover/movie", queryItems: queryItems) { (result: Result<MovieResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        apiClient.performRequest(
            endpoint: "movie/\(id)",
            queryItems: queryItems,
            completion: completion
        )
    }
    
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        if !genresCache.isEmpty {
            let genres = genresCache.map { Genre(id: $0.key, name: $0.value) }
            completion(.success(genres))
            return
        }
        
        let queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        apiClient.performRequest(endpoint: "genre/movie/list", queryItems: queryItems) { (result: Result<GenreResponse, Error>) in
            switch result {
            case .success(let response):
                //                print("res \(response.genres)")
                completion(.success(response.genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
