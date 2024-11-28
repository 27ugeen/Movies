//
//  AppCoordinator.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let apiClient: APIClientProtocol
    private let movieService: MovieServiceProtocol
    private let networkMonitor: NetworkMonitorProtocol
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.apiClient = APIClient()
        self.movieService = MovieService(apiClient: apiClient)
        self.networkMonitor = NetworkMonitor.shared
    }
    
    func start() {
        let viewModel = MovieListViewModel(movieService: movieService, networkMonitor: networkMonitor)
        let movieListVC = MovieListViewController(viewModel: viewModel)
        movieListVC.parentCoordinator = self
        navigationController.pushViewController(movieListVC, animated: true)
    }
    
    func showMovieDetails(with movieID: Int) {
        let viewModel = MovieDetailViewModel(movieID: movieID, movieService: movieService, networkMonitor: networkMonitor)
        let detailVC = MovieDetailViewController(viewModel: viewModel)
        detailVC.parentCoordinator = self
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func showPosterView(for posterURL: URL) {
        let posterVC = PosterViewController(posterURL: posterURL)
        posterVC.modalPresentationStyle = .fullScreen
        navigationController.present(posterVC, animated: true, completion: nil)
    }
}
