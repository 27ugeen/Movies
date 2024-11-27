//
//  MovieListViewModel.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

final class MovieListViewModel {
    private let movieService: MovieServiceProtocol
    private(set) var movies: [Movie] = []
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func fetchMovies(page: Int) {
        movieService.fetchPopularMovies(page: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies.append(contentsOf: movies)
                    self?.onMoviesUpdated?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
