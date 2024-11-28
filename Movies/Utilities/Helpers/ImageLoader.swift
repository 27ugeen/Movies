//
//  ImageLoader.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import UIKit
import Kingfisher

final class ImageLoader {
    @MainActor static func loadImage(
        into imageView: UIImageView,
        from urlString: String,
        placeholder: UIImage? = nil,
        onError: ((String) -> Void)? = nil
    ) {
        guard let url = URL(string: urlString) else {
            onError?("Invalid image URL.")
            return
        }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ],
            completionHandler: { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    onError?("Failed to load image: \(error.localizedDescription)")
                }
            }
        )
    }
}
