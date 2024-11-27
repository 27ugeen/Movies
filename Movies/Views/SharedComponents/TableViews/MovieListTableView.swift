//
//  MovieListTableView.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class MovieListTableView: UITableView {
    init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
        
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .singleLine
        isScrollEnabled = true
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        scrollIndicatorInsets = contentInset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(separatorStyle: UITableViewCell.SeparatorStyle = .none, isScrollEnabled: Bool = true) {
        self.separatorStyle = separatorStyle
        self.isScrollEnabled = isScrollEnabled
    }
}
