//
//  MovieListViewController.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    private let viewModel: MovieListViewModel
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
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
    }
    
    private func fetchGenresAndMovies() {
        viewModel.fetchGenres { [weak self] in
            guard let self else { return }
            viewModel.fetchMovies(page: 1, sortBy: viewModel.currentSortOption)
        }
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func setupUI() {
        setupView()
        setupSearchBar()
        setupTableView()
        addSortButton()
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupView() {
        title = "Popular Movies"
        view.backgroundColor = .white
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search movies"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = viewModel.filteredMovies[indexPath.row]
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
        // Handle movie selection
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
        viewModel.searchMovies(by: searchText)
    }
}
