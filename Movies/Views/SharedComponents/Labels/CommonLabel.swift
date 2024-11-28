//
//  CommonLabel.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class CommonLabel: UILabel {
    init(title: String = "") {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        text = title
        textAlignment = .left
        textColor = .white
        font = UIFont.systemFont(ofSize: 14)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
