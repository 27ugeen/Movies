//
//  VideoPlayer.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import UIKit
import WebKit

final class VideoPlayerHelper {
    static func playVideo(from url: URL, on viewController: UIViewController) {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false

        let videoViewController = UIViewController()
        videoViewController.view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: videoViewController.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: videoViewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: videoViewController.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: videoViewController.view.bottomAnchor)
        ])

        webView.load(URLRequest(url: url))
        viewController.present(videoViewController, animated: true)
    }
}
