//
//  AppAppearance.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import UIKit

final class AppAppearance {
    static func configure() {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }
}
