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
        navigationController.pushViewController(movieListVC, animated: true)
    }
}
