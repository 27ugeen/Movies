//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import Foundation

final class MovieDetailViewModel {
    private let movieID: Int
    private let movieService: MovieServiceProtocol
    
    var movieDetails: MovieDetails? {
        didSet {
            onDetailsUpdated?()
        }
    }
    var onDetailsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(movieID: Int, movieService: MovieServiceProtocol) {
        self.movieID = movieID
        self.movieService = movieService
    }
    
    func fetchMovieDetails() {
        movieService.fetchMovieDetails(id: movieID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.movieDetails = details
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}
