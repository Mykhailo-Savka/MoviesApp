//
//  FavoriteViewPresenter.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import Foundation

// MARK: - FavouriteViewPresenterProtocol
protocol FavouriteViewPresenterProtocol: AnyObject {
    var movies: [Movie] { get }
    
    func viewLoaded()
    func favouriteButtonTapped(for index: Int)
    func getMovies()
    func cellDidTapped(movie: Movie)
}

// MARK: - FavouriteViewPresenter
final class FavouriteViewPresenter {
    
    // MARK: - Public properties
    weak var view: FavouriteViewControllerProtocol?
    
    // MARK: - Private properties
    private let moviesManager = MoviesManager.shared
    private (set) var movies: [Movie] = []
    
    // MARK: - Lifecycle
    init(view: FavouriteViewControllerProtocol) {
        self.view = view
        movies = moviesManager.getMovies()
    }
}

// MARK: - FavouriteViewPresenterProtocol implementation
extension FavouriteViewPresenter: FavouriteViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI()
    }
    
    func favouriteButtonTapped(for index: Int) {
        let movie = movies[index]
        moviesManager.manage(movie)
        getMovies()
    }
    
    func getMovies() {
        movies = moviesManager.getMovies()
        view?.reloadData()
    }
    
    func cellDidTapped(movie: Movie) {
        view?.pushDetailViewController(with: movie)
    }
}
