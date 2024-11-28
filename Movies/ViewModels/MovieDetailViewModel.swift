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
    private let networkMonitor: NetworkMonitorProtocol
    
    private(set) var movieDetails: MovieDetails?
    private(set) var movieVideos: [MovieVideo] = []
    
    var onDetailsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onNetworkStatusChange: ((Bool) -> Void)?
    
    init(movieID: Int, 
         movieService: MovieServiceProtocol,
         networkMonitor: NetworkMonitorProtocol) {
        self.movieID = movieID
        self.movieService = movieService
        self.networkMonitor = networkMonitor
        
        networkMonitor.delegate = self
        onNetworkStatusChange?(networkMonitor.isConnected)
    }
    
    func fetchMovieDetails() {
        movieService.fetchMovieDetails(id: movieID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.movieDetails = details
                    self?.onDetailsUpdated?()
                    if details.video {
                        self?.fetchMovieVideos(id: self?.movieID)
                    }
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchMovieVideos(id: Int?) {
        guard let id else { return }
        movieService.fetchMovieVideos(id: id) { [weak self] result in
            switch result {
            case .success(let videos):
                self?.movieVideos = videos
                self?.onDetailsUpdated?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}

extension MovieDetailViewModel: NetworkMonitorDelegate {
    func networkStatusDidChange(isConnected: Bool) {
        onNetworkStatusChange?(isConnected)
    }
}
