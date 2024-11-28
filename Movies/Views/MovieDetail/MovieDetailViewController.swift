//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    private let viewModel: MovieDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = BackdropImageView()
    private let titleLabel = MovieDetailLabel()
    private let countryLabel = MovieDetailLabel()
    private let releaseYearLabel = MovieDetailLabel()
    private let genresLabel = MovieDetailLabel()
    private let descriptionLabel = MovieDetailLabel()
    private let ratingLabel = MovieDetailLabel()
    private let trailerButton = UIButton(type: .system)
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMovieDetails()
        bindViewModel()
        setupUI()
    }
    
    private func bindViewModel() {
        viewModel.onDetailsUpdated = { [weak self] in
            self?.populateData()
        }
        viewModel.onError = { [weak self] errorMessage in
            self?.showAlert(title: "Error", message: errorMessage)
        }
    }
    
    private func populateData() {
        guard let details = viewModel.movieDetails else { return }
        title = details.title
        titleLabel.text = details.title
        countryLabel.text = "Country: \(details.productionCountries?.joined(separator: ", ") ?? "N/A")"
        releaseYearLabel.text = "Year: \(details.releaseDate?.split(separator: "-").first ?? "N/A")"
        genresLabel.text = "Genres: \(details.genres?.map { $0.name }.joined(separator: ", ") ?? "No genres available")"
        descriptionLabel.text = details.overview ?? "Description not avaliable"
        ratingLabel.text = details.voteAverage.map { String(format: "Rating: %.1f", $0) } ?? "Rating: N/A"
        trailerButton.isHidden = !details.video
        
        if let posterPath = details.posterPath {
            loadImage(from: "https://image.tmdb.org/t/p/w780\(posterPath)")
        } else {
            posterImageView.image = UIImage(named: "cat")
        }
        
        if let trailer = viewModel.movieVideos.first(where: { $0.type == "Trailer" }) {
            trailerButton.isHidden = false
            trailerButton.addTarget(self, action: #selector(trailerButtonTapped), for: .touchUpInside)
            trailerButton.tag = trailer.key.hash
            trailerButton.setTitle("Watch Trailer (\(trailer.site))", for: .normal)
        } else {
            trailerButton.isHidden = true
        }
    }
    
    private func loadImage(from urlString: String) {
        ImageLoader.loadImage(
            into: posterImageView,
            from: urlString,
            onError: { [weak self] errorMessage in
                self?.showAlert(title: "Image Error", message: errorMessage)
            }
        )
    }
    
    @objc private func trailerButtonTapped() {
        guard let trailer = viewModel.movieVideos.first(where: { $0.type == "Trailer" }) else {
            showAlert(title: "No Trailer Found", message: "Unfortunately, there is no trailer available for this movie.")
            return
        }
        
        let videoURLString: String
        switch trailer.site.lowercased() {
        case "youtube":
            videoURLString = "https://www.youtube.com/embed/\(trailer.key)?autoplay=1"
        case "vimeo":
            videoURLString = "https://player.vimeo.com/video/\(trailer.key)?autoplay=1"
        default:
            print("Unsupported video site: \(trailer.site)")
            return
        }
        
        guard let url = URL(string: videoURLString) else {
            showAlert(title: "Invalid URL", message: "The video URL could not be created.")
            return
        }
        VideoPlayerHelper.playVideo(from: url, on: self)
    }
    
    //    private func loadImage(from url: URL) {
    //        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
    //            guard let data = data, error == nil else { return }
    //            DispatchQueue.main.async {
    //                self?.posterImageView.image = UIImage(data: data)
    //            }
    //        }.resume()
    //    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            posterImageView.heightAnchor.constraint(equalToConstant: 434)
        ])
        
        setupLabels()
        setupTrailerButton()
    }
    
    private func setupLabels() {
        [titleLabel, countryLabel, releaseYearLabel, genresLabel, descriptionLabel, ratingLabel].forEach {
            contentView.addSubview($0)
        }
        
        posterImageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        genresLabel.font = UIFont.boldSystemFont(ofSize: 14)
        genresLabel.textColor = .gray
        ratingLabel.textColor = .systemOrange
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            countryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            releaseYearLabel.topAnchor.constraint(equalTo: countryLabel.topAnchor),
            releaseYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            genresLabel.topAnchor.constraint(equalTo: releaseYearLabel.bottomAnchor, constant: 8),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTrailerButton() {
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        trailerButton.setTitle("Watch Trailer", for: .normal)
        trailerButton.isHidden = true
        trailerButton.addTarget(self, action: #selector(trailerButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(trailerButton)
        NSLayoutConstraint.activate([
            trailerButton.topAnchor.constraint(equalTo: ratingLabel.topAnchor),
            trailerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}
