//
//  SceneDelegate.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        self.window = window
        
        let navigationController = UINavigationController()
        
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
        
//        testAPI()
    }
    
    private func testAPI() {
        let apiClient = APIClient()
        let movieService = MovieService(apiClient: apiClient)
        
        movieService.fetchPopularMovies(page: 1) { result in
            switch result {
            case .success(let movies):
                print("Movies fetched: \(movies)")
            case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
        
        movieService.fetchMovieDetails(id: 912649) { result in
            switch result {
            case .success(let movieDetails):
                print("Movie Details: \(movieDetails)")
            case .failure(let error):
                print("Error fetching movie details: \(error.localizedDescription)")
            }
        }
    }
}
