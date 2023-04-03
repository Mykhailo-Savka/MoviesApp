//
//  MoviesViewPresenter.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import Foundation

// MARK: - MoviesViewPresenterProtocol
protocol MoviesViewPresenterProtocol: AnyObject {
    var movies: [Movie] { get }
    var favouriteMovies: [Movie] { get }
    
    func viewLoaded()
    func searchMovie(by text: String)
    func favouriteButtonTapped(for index: Int)
    func cellDidTapped(movie: Movie)
}

// MARK: - MoviesViewPresenter
final class MoviesViewPresenter {
    
    // MARK: - Public properties
    weak var view: MoviesViewControllerProtocol?
    
    // MARK: - Private properties
    private let network = NetworkManager()
    private let moviesManager = MoviesManager.shared
    private (set) var movies: [Movie] = []
    private (set) var favouriteMovies: [Movie] = []
    
    // MARK: - Lifecycle
    init(view: MoviesViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Private methods
    private func fetchData(searchText: String) {
        view?.showLoader()
        network.fetchData(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let searchResponse):
                    self.view?.hideLoader()
                    self.movies = searchResponse.results
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.hideLoader()
                    self.view?.createAlert(with: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - MoviesViewPresenterProtocol implementation
extension MoviesViewPresenter: MoviesViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI()
    }
    
    func searchMovie(by text: String) {
        fetchData(searchText: text)
    }
    
    func favouriteButtonTapped(for index: Int) {
        let movie = movies[index]
        let movieCopy = Movie(value: movie)
        moviesManager.manage(movieCopy)
    }
    
    func cellDidTapped(movie: Movie) {
        view?.pushDetailViewController(with: movie)
    }
}
