//
//  APIClient.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation
import Alamofire

protocol APIClientProtocol {
    func performRequest<T: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem],
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class APIClient: APIClientProtocol {
    private let baseURL = "https://api.themoviedb.org/3/"
    private let bearerToken: String = {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "MOVIE_DB_BEARER_TOKEN") as? String else {
            fatalError("Bearer Token is missing in Info.plist")
        }
        return token
    }()
    
    func performRequest<T: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        AF.request(url, method: .get, headers: [
            "Authorization": "Bearer \(bearerToken)",
            "Accept": "application/json"
        ]).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodedResponse):
                completion(.success(decodedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
