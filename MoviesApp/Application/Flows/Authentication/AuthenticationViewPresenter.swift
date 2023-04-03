//
//  AuthenticationViewPresenter.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 28.03.2023.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

// MARK: - AuthenticationViewPresenterProtocol
protocol AuthenticationViewPresenterProtocol: AnyObject {
    func viewLoaded()
    func authentication()
    func nameDidChanged(_ text: String)
    func emailDidChanged(_ text: String)
    func passwordDidChanged(_ text: String)
    func accountButtonTapped()
    func getUserImage(_ image: UIImage?)
    func presentActionSheet()
}

// MARK: - AuthenticationViewPresenter
final class AuthenticationViewPresenter {
    
    // MARK: - Public properties
    weak var view: AuthenticationViewControllerProtocol?
    
    // MARK: - Private properties
    private var type: AuthenticationScreenType
    private var name = ""
    private var email = ""
    private var password = ""
    private var userImage: UIImage?
    
    // MARK: - Lifecycle
    init(view: AuthenticationViewControllerProtocol, type: AuthenticationScreenType) {
        self.view = view
        self.type = type
    }
    
    // MARK: - Private methods
    private func signIn() {
        guard email.isEmailValid(), password.count >= 6 else {
            view?.createAlert(with: Constants.signInAlert)
            return
        }
        view?.showLoader()
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            guard result != nil, error == nil else {
                self.view?.hideLoader()
                self.view?.createAlert(with: error?.localizedDescription ?? "")
                return
            }
            self.view?.hideLoader()
            self.view?.showMoviesTabBarController(name: result?.user.displayName,
                                                  email: result?.user.email,
                                                  imageURL: result?.user.photoURL)
        })
    }
    
    private func signUp() {
        guard email.isEmailValid(), password.count >= 6, !name.isEmpty, let userImage else {
            view?.createAlert(with: Constants.signUpAlert)
            return
        }
        view?.showLoader()
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            guard result != nil, error == nil else {
                self.view?.hideLoader()
                self.view?.createAlert(with: error?.localizedDescription ?? "")
                return
            }
            self.uploadProfileImage(userImage) { url in
                guard let url else { return }
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.name
                changeRequest?.photoURL = url
                changeRequest?.commitChanges(completion: { error in
                    if error == nil {
                        self.view?.hideLoader()
                        NotificationCenter.default.post(name: NSNotification.Name("DataUploaded"),
                                                        object: nil)
                    } else {
                        self.view?.hideLoader()
                        self.view?.createAlert(with: error?.localizedDescription ?? "")
                    }
                })
            }
        })
    }
    
    private func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url: URL?) -> () )) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let riversRef = storageRef.child("images/images.jpg")
        riversRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                self.view?.createAlert(with: error?.localizedDescription ?? "")
                completion(nil)
                return
            }
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    self.view?.createAlert(with: error?.localizedDescription ?? "")
                    completion(nil)
                    return
                }
                completion(downloadURL)
            }
        }
    }
}

// MARK: - AuthenticationViewPresenterProtocol implementation
extension AuthenticationViewPresenter: AuthenticationViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI(with: type)
    }
    
    func authentication() {
        type == .signIn ? signIn() : signUp()
    }
    
    func nameDidChanged(_ text: String) {
        name = text
    }
    
    func emailDidChanged(_ text: String) {
        email = text
    }
    
    func passwordDidChanged(_ text: String) {
        password = text
    }
    
    func accountButtonTapped() {
        type = type == .signIn ? .signUp : .signIn
        view?.setupUI(with: type)
    }
    
    func getUserImage(_ image: UIImage?) {
        userImage = image
    }
    
    func presentActionSheet() {
        view?.presentActionSheet()
    }
}
