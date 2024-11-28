//
//  MovieDetailLabel.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import UIKit

final class MovieDetailLabel: UILabel {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        textAlignment = .left
        textColor = .black
        font = UIFont.systemFont(ofSize: 16)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
