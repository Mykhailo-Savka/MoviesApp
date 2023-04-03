//
//  ProfileViewPresenter.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import Foundation
import FirebaseAuth

// MARK: - ProfileViewPresenterProtocol
protocol ProfileViewPresenterProtocol: AnyObject {
    func viewLoaded()
    func signOutButtonTapped()
    func fetchUserData()
}

// MARK: - ProfileViewPresenter
final class ProfileViewPresenter {
    
    // MARK: - Public properties
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private properties
    private var name: String?
    private var email: String?
    private var imageURL: URL?
    
    // MARK: - Lifecycle
    init(view: ProfileViewControllerProtocol, name: String?, email: String?, imageURL: URL?) {
        self.view = view
        self.name = name
        self.email = email
        self.imageURL = imageURL
    }
}

// MARK: - ProfileViewPresenterProtocol implementation
extension ProfileViewPresenter: ProfileViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI(imageURL: imageURL, name: name, email: email)
    }
    
    func signOutButtonTapped() {
        view?.createAlert()
    }
    
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            name = user.displayName
            email = user.email
            imageURL = user.photoURL
            view?.setupUI(imageURL: imageURL, name: name, email: email)
        }
    }
}
