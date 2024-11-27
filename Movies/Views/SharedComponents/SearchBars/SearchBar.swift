//
//  SearchBar.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class SearchBar: UISearchBar {
    init(placeholder: String = "Search movies") {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        searchBarStyle = .minimal
        backgroundColor = .clear
        searchTextField.backgroundColor = .white
        searchTextField.textColor = .black
        
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
