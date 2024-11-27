//
//  MovieListViewModel.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

final class MovieListViewModel {
    private let movieService: MovieServiceProtocol
    private(set) var movies: [Movie] = [] {
        didSet {
            filteredMovies = movies
        }
    }
    private(set) var filteredMovies: [Movie] = []
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func fetchMovies(page: Int) {
        movieService.fetchPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies.append(contentsOf: movies)
                self?.onMoviesUpdated?()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func searchMovies(by query: String) {
        if query.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
        onMoviesUpdated?()
    }
}
