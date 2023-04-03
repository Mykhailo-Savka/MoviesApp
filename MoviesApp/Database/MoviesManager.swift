//
//  MoviesManager.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 31.03.2023.
//

import Foundation
import RealmSwift

// MARK: - MoviesManager
class MoviesManager {
    
    // MARK: - Public properties
    static let shared = MoviesManager()
    
    // MARK: - Private properties
    private let databaseService = DatabaseService<Movie>()
    
    // MARK: - Lifecycle
    private init() { }
    
    // MARK: - Public methods
    func manage(_ movie: Movie) {
        if let existingObject = databaseService.getObjects().first(where: {
            $0.trackId == movie.trackId
        }) {
            databaseService.delete(object: existingObject)
        } else {
            databaseService.add(object: movie)
        }
    }
    
    func delete(_ movie: Movie) {
        databaseService.delete(object: movie)
    }
    
    func getMovies() -> [Movie] {
        databaseService.getObjects()
    }
    
    func contains(_ movie: Movie) -> Bool {
        if let _ = databaseService.getObjects().first(where: { $0.trackId == movie.trackId }) {
            return true
        } else {
            return false
        }
    }
}
