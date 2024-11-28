//
//  UIViewController+Extension.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import UIKit

extension UIViewController {
    /// Shows an alert with a given title and message.
    /// - Parameters:
    ///   - title: The title of the alert. Defaults to `nil`.
    ///   - message: The message of the alert. Defaults to `nil`.
    ///   - actions: An array of `UIAlertAction` to add to the alert. Defaults to a single "OK" action.
    func showAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
