//
//  AppRouter.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 27.03.2023.
//

import UIKit
import FirebaseAuth

// MARK: - AppRouter
class AppRouter {
    
    // MARK: - Life cycle
    private init() {}
    
    // MARK: - Public properties
    static let instance = AppRouter()
    
    // MARK: - Public functions
    func startApp(window: UIWindow?) {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            user != nil ?
            self?.showMainScreen(window: window,
                                 name: user?.displayName,
                                 email: user?.email,
                                 imageURL: user?.photoURL) :
            self?.showAuthenticationScreen(window: window)
        }
    }
    
    // MARK: - Private functions
    private func showMainScreen(window: UIWindow?, name: String?, email: String?, imageURL: URL?) {
        let moviesTabBarController = MoviesTabBarController.instantiateFromStoryboard()
        moviesTabBarController.name = name
        moviesTabBarController.email = email
        moviesTabBarController.imageURL = imageURL
        window?.rootViewController = moviesTabBarController
    }
    
    private func showAuthenticationScreen(window: UIWindow?) {
        let authenticationViewController = AuthenticationViewController.instantiateFromStoryboard()
        let presenter = AuthenticationViewPresenter(view: authenticationViewController, type: .signIn)
        authenticationViewController.presenter = presenter
        window?.rootViewController = authenticationViewController
    }
}
