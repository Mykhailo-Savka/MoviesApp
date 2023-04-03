//
//  MoviesTabBarController.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import UIKit

// MARK: - MoviesTabBarController
final class MoviesTabBarController: UITabBarController {
    
    // MARK: - Public properties
    var name: String?
    var email: String?
    var imageURL: URL?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenters()
    }
    
    // MARK: - Private methods
    private func setupPresenters() {
        guard let controllers = self.viewControllers else {
            return
        }
        
        controllers.forEach {
            guard let navigationController = $0 as? UINavigationController else {
                return
            }
            
            if let moviesViewController = navigationController.viewControllers.first as? MoviesViewController {
                let presenter = MoviesViewPresenter(view: moviesViewController)
                moviesViewController.presenter = presenter
            } else if let favouriteViewController = navigationController.viewControllers.first as? FavouriteViewController {
                let presenter = FavouriteViewPresenter(view: favouriteViewController)
                favouriteViewController.presenter = presenter
            } else if let profileViewController = navigationController.viewControllers.first as? ProfileViewController {
                let presenter = ProfileViewPresenter(view: profileViewController,
                                                     name: name,
                                                     email: email,
                                                     imageURL: imageURL)
                profileViewController.presenter = presenter
            }
        }
    }
}
