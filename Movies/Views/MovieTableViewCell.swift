//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    private let backdropImageView = UIImageView()
    private let overlayView = UIView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBackDrop()
        setupLabels()
        
        contentView.addSubview(backdropImageView)
        backdropImageView.addSubview(overlayView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            backdropImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            overlayView.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: backdropImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: releaseDateLabel.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.topAnchor, constant: 12),
            
            releaseDateLabel.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor, constant: -12),
            releaseDateLabel.topAnchor.constraint(equalTo: backdropImageView.topAnchor, constant: 12),
            releaseDateLabel.widthAnchor.constraint(equalToConstant: 80),
            
            genreLabel.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor, constant: 12),
            genreLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingLabel.leadingAnchor, constant: -12),
            genreLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -12),
            
            ratingLabel.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor, constant: -12),
            ratingLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -12),
            ratingLabel.widthAnchor.constraint(equalToConstant: 88),
        ])
    }
    
    private func setupBackDrop() {
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        backdropImageView.layer.cornerRadius = 8
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func setupLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.font = UIFont.systemFont(ofSize: 14)
        genreLabel.textColor = .white
        genreLabel.numberOfLines = 0
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.textColor = .systemOrange
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .white
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }
    
    func configure(with movie: Movie, genres: [Int: String]) {
        let genreNames = movie.genreIds?.compactMap { genres[$0] } ?? []
        
        genreLabel.text = genreNames.isEmpty ? "No genres available" : genreNames.joined(separator: ", ")
        titleLabel.text = movie.title
        ratingLabel.text = movie.voteAverage.map { String(format: "Rating: %.1f", $0) } ?? "Rating: N/A"
        releaseDateLabel.text = movie.releaseDate?.split(separator: "-").first.map { "Year: \($0)" } ?? "Year: N/A"
        
        if let backdropPath = movie.backdropPath {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
            if let url = imageURL {
                loadImage(from: url)
            } else {
                backdropImageView.image = nil
            }
        } else {
            backdropImageView.image = nil
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.backdropImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
