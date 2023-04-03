//
//  Movie.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import Foundation
import RealmSwift

// MARK: - Movie
class Movie: Object, Codable {
    @Persisted var trackId: Int?
    @Persisted var trackName: String?
    @Persisted var artworkUrl100: String?
    @Persisted var shortDescription: String?
    @Persisted var longDescription: String?
    @Persisted var releaseDate: String?
    @Persisted var primaryGenreName: String?
    @Persisted var trackViewUrl: String?
    
    override required init() { }
}
