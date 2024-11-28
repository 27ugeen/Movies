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
    private let networkMonitor: NetworkMonitorProtocol
    private let debouncer: Debouncer
    
    private(set) var movies: [Movie] = []
    private(set) var filteredMovies: [Movie] = []
    private(set) var foundMovies: [Movie] = []
    private(set) var genres: [Int: String] = [:]
    
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onNetworkStatusChange: ((Bool) -> Void)?
    
    private var currentPage: Int = 1
    
    var searchBarIsActive: Bool = false
    var currentSortOption: MovieSortOption = .popularityDescending
    
    init(movieService: MovieServiceProtocol, 
         networkMonitor: NetworkMonitorProtocol,
         debounceDelay: TimeInterval = 0.7) {
        self.movieService = movieService
        self.networkMonitor = networkMonitor
        self.debouncer = Debouncer(delay: debounceDelay)
        
        networkMonitor.delegate = self
        onNetworkStatusChange?(networkMonitor.isConnected)
    }
    
    func fetchMovies(page: Int, sortBy: MovieSortOption, completion: (() -> Void)? = nil) {
        defer { completion?() }
        
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
//            print("started fetchPopularMovies")
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
        if !searchBarIsActive {
            currentPage += 1
            fetchMovies(page: currentPage, sortBy: currentSortOption)
        }
    }
    
    func sortMovies(by option: MovieSortOption) {
        currentSortOption = option
        currentPage = 1
        fetchMovies(page: currentPage, sortBy: option)
    }
    
    func searchMovies(by query: String, page: Int = 1) {
        movieService.searchMovies(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.foundMovies = movies
                self?.onMoviesUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func searchMoviesDebounced(query: String) {
        debouncer.debounce { [weak self] in
            self?.searchMovies(by: query)
        }
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

extension MovieListViewModel: NetworkMonitorDelegate {
    func networkStatusDidChange(isConnected: Bool) {
        onNetworkStatusChange?(isConnected)
    }
}
