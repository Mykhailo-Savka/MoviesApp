//
//  SearchResponse.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let results: [Movie]
}
