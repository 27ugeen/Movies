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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.apiClient = APIClient()
        self.movieService = MovieService(apiClient: apiClient)
    }
    
    func start() {
        let viewModel = MovieListViewModel(movieService: movieService)
        let movieListVC = MovieListViewController(viewModel: viewModel)
        movieListVC.parentCoordinator = self 
        navigationController.pushViewController(movieListVC, animated: true)
    }
    
    func showMovieDetails(with movieID: Int) {
        let viewModel = MovieDetailViewModel(movieID: movieID, movieService: movieService)
        let detailVC = MovieDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
