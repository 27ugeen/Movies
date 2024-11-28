//
//  MovieListViewController.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    weak var parentCoordinator: AppCoordinator?
    
    private let viewModel: MovieListViewModel
    
    private let searchBar = SearchBar()
    private let tableView = MovieListTableView()
    private let emptyStateView = EmptyStateView()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGenresAndMovies()
        bindViewModel()
        setupUI()
        setupRefreshControl()
        setupKeyboardDismissal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Force initialization of the UISearchBar focus to eliminate the delay
        searchBar.becomeFirstResponder()
        searchBar.resignFirstResponder()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func fetchGenresAndMovies() {
        toggleLoadingIndicator(true)
        viewModel.fetchGenres { [weak self] in
            guard let self else { return }
            viewModel.fetchMovies(page: 1, sortBy: viewModel.currentSortOption) {
                self.toggleLoadingIndicator(false)
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            guard let self else { return }
            
            //need rewrite hasMovies
            let hasMovies: Bool
            if searchBar.text?.isEmpty == false {
                hasMovies = !viewModel.foundMovies.isEmpty
            } else {
                hasMovies = !viewModel.filteredMovies.isEmpty
            }
            
            emptyStateView.isHidden = hasMovies
            tableView.isHidden = !hasMovies
            tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.toggleLoadingIndicator(false)
            self?.refreshControl.endRefreshing()
            self?.showAlert(title: "Error", message: errorMessage)
        }
        viewModel.onNetworkStatusChange = { [weak self] isConnected in
            if !isConnected {
                self?.showAlert(
                    title: "No Internet",
                    message: "You are offline. Please, enable your Wi-Fi or connect using cellular data."
                )
            }
        }
    }
    
    private func setupUI() {
        setupViews()
        addSortButton()
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(emptyStateView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViews() {
        title = "Popular Movies"
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshMovies() {
        viewModel.fetchMovies(page: 1, sortBy: viewModel.currentSortOption) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func toggleLoadingIndicator(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    private func addSortButton() {
        let sortButton = UIBarButtonItem(
            title: "Sort",
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func updateSortButtonVisibility() {
        if viewModel.searchBarIsActive {
            navigationItem.rightBarButtonItem = nil
        } else {
            addSortButton()
        }
    }
    
    @objc private func didTapSortButton() {
        let actionSheet = UIAlertController(
            title: "Sort Movies",
            message: "Select sorting option",
            preferredStyle: .actionSheet
        )
        
        let options: [(String, MovieSortOption)] = [
            ("Popularity (High-Low)", .popularityDescending),
            ("Popularity (Low-High)", .popularityAscending),
            ("Rating (High-Low)", .ratingDescending),
            ("Rating (Low-High)", .ratingAscending)
        ]
        
        for (title, option) in options {
            let action = UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                self?.viewModel.sortMovies(by: option)
            })
            if option == viewModel.currentSortOption {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func sortMovies(by option: MovieSortOption) {
        viewModel.sortMovies(by: option)
    }
    
    private func cleanSearch() {
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()
        viewModel.searchBarIsActive = false
        updateSortButtonVisibility()
        tableView.reloadData()
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchBarIsActive ? viewModel.foundMovies.count : viewModel.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = viewModel.searchBarIsActive ? viewModel.foundMovies[indexPath.row] : viewModel.filteredMovies[indexPath.row]
        cell.configure(with: movie, genres: viewModel.genres)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 217
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cleanSearch()
        let movie = viewModel.searchBarIsActive ? viewModel.foundMovies[indexPath.row] : viewModel.filteredMovies[indexPath.row]
        parentCoordinator?.showMovieDetails(with: movie.id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.loadMoreMovies()
        }
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            cleanSearch()
            return
        }
        
        viewModel.searchBarIsActive = true
        viewModel.searchMoviesDebounced(query: searchText)
        updateSortButtonVisibility()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        cleanSearch()
    }
}
