//
//  DetailViewPresenter.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 02.04.2023.
//

import Foundation

// MARK: - DetailViewPresenterProtocol
protocol DetailViewPresenterProtocol: AnyObject {
    func viewLoaded()
    func shareButtonTapped()
}

// MARK: - DetailViewPresenter
final class DetailViewPresenter {
    
    // MARK: - Public properties
    weak var view: DetailViewControllerProtocol?
    
    // MARK: - Private properties
    private let movie: Movie
    
    // MARK: - Lifecycle
    init(view: DetailViewControllerProtocol, movie: Movie) {
        self.view = view
        self.movie = movie
    }
}

// MARK: - DetailViewPresenterProtocol implementation
extension DetailViewPresenter: DetailViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI(with: movie)
    }
    
    func shareButtonTapped() {
        view?.shareLink(for: movie)
    }
}
