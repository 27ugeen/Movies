//
//  OverlayView.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import UIKit

final class OverlayView: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

