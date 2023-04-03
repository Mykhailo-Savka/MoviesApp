//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import Foundation

// MARK: - NetworkManager
class NetworkManager {
    
    // MARK: - Public method
    func fetchData(searchText: String, completionHandler: @escaping (Result<SearchResponse, Error>) -> Void) {
        if var components = URLComponents(string: Constants.baseURL) {
            components.queryItems = [
                URLQueryItem(name: "term", value: searchText),
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "media", value: "movie")
            ]
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                
                guard let data else {
                    print("Error: No data")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SearchResponse.self, from: data)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
}
