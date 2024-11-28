//
//  PosterViewController.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import UIKit

final class PosterViewController: UIViewController {
    
    private let posterImageView = UIImageView()
    private let scrollView = UIScrollView()
    
    private let posterURL: URL
    
    init(posterURL: URL) {
        self.posterURL = posterURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPosterImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // ScrollView setup
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // ImageView setup
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            posterImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            posterImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            posterImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        // Add swipe-to-dismiss
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
        
        // Add close button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func loadPosterImage() {
        posterImageView.kf.setImage(with: posterURL, placeholder: UIImage(named: "cat"))
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImageView
    }
}
