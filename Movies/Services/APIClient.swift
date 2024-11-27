//
//  APIClient.swift
//  Movies
//
//  Created by GiN Eugene on 27/11/2024.
//

import Foundation

protocol APIClientProtocol {
    func performRequest<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void)
}

final class APIClient: APIClientProtocol {
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "YOUR_API_KEY"

    func performRequest<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint + "&api_key=\(apiKey)") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
