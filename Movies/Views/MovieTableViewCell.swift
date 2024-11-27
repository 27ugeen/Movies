//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingLabel = UILabel()
    private let releaseDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(releaseDateLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5),
            
            releaseDateLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 10),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5)
        ])
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        genreLabel.font = UIFont.systemFont(ofSize: 14)
        genreLabel.textColor = .gray
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.textColor = .systemBlue
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .gray
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        genreLabel.text = "Genres not available"
        ratingLabel.text = String(format: "Rating: %.1f", movie.voteAverage)
        
        if let releaseYear = movie.releaseDate.split(separator: "-").first {
            releaseDateLabel.text = "Year: \(releaseYear)"
        } else {
            releaseDateLabel.text = "Year: N/A"
        }
        
        if let posterPath = movie.posterPath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            if let url = imageURL {
                loadImage(from: url)
            } else {
                posterImageView.image = nil
            }
        } else {
            posterImageView.image = nil
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.posterImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
