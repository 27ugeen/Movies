//
//  BackdropImageView.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class BackdropImageView: UIImageView {
    init(image: String = "") {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
//        image = UIImage(named: image)
        backgroundColor = .white
        contentMode = .scaleAspectFill
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
