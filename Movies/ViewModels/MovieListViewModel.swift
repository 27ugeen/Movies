//
//  MovieListViewModel.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

enum MovieSortOption {
    case popularityDescending
    case popularityAscending
    case ratingDescending
    case ratingAscending
}

final class MovieListViewModel {
    private let movieService: MovieServiceProtocol
    private(set) var movies: [Movie] = [] {
        didSet {
            filteredMovies = movies
        }
    }
    private(set) var filteredMovies: [Movie] = []
    private(set) var genres: [Int: String] = [:]
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private var currentPage: Int = 1
    var currentSortOption: MovieSortOption = .popularityDescending
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func fetchMovies(page: Int, sortBy: MovieSortOption) {
        let sortQuery: String
        switch sortBy {
        case .popularityDescending:
            sortQuery = "popularity.desc"
        case .popularityAscending:
            sortQuery = "popularity.asc"
        case .ratingDescending:
            sortQuery = "vote_average.desc"
        case .ratingAscending:
            sortQuery = "vote_average.asc"
        }
        
        movieService.fetchPopularMovies(page: page, sortBy: sortQuery) { [weak self] result in
            switch result {
            case .success(let movies):
                if page == 1 {
                    self?.movies = movies
                } else {
                    self?.movies.append(contentsOf: movies)
                }
                self?.filteredMovies = self?.movies ?? []
                self?.onMoviesUpdated?()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func loadMoreMovies() {
        currentPage += 1
        fetchMovies(page: currentPage, sortBy: currentSortOption)
    }
    
    func sortMovies(by option: MovieSortOption) {
        currentSortOption = option
        currentPage = 1
        fetchMovies(page: currentPage, sortBy: option)
    }
    
    func searchMovies(by query: String) {
        if query.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
        onMoviesUpdated?()
    }
    
    func fetchGenres(completion: @escaping () -> Void) {
        movieService.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                self?.genres = genres.reduce(into: [:]) { $0[$1.id] = $1.name }
                completion()
            case .failure(let error):
                print("Failed to fetch genres: \(error.localizedDescription)")
                completion()
            }
        }
    }
}
