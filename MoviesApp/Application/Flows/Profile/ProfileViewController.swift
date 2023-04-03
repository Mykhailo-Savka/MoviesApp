//
//  ProfileViewController.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 29.03.2023.
//

import UIKit
import Kingfisher
import FirebaseAuth

// MARK: - ProfileViewControllerProtocol
protocol ProfileViewControllerProtocol: AnyObject {
    func setupUI(imageURL: URL?, name: String?, email: String?)
    func createAlert()
}

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    // MARK: - Public properties
    var presenter: ProfileViewPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
        addUserDataObserver()
    }
    
    // MARK: - Private methods
    private func addUserDataObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name("DataUploaded"), object: nil)
    }
    
    @objc private func fetchData() {
        presenter.fetchUserData()
    }
    
    // MARK: - IBAction
    @IBAction private func onSignOutButton(_ sender: UIButton) {
        presenter.signOutButtonTapped()
    }
}

// MARK: - ProfileViewControllerProtocol implementation
extension ProfileViewController: ProfileViewControllerProtocol {
    func setupUI(imageURL: URL?, name: String?, email: String?) {
        userImage.kf.setImage(with: imageURL)
        nameLabel.text = name
        emailLabel.text = email
    }
    
    func createAlert() {
        let alertController = UIAlertController(title: nil,
                                                message: Constants.signOutMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.cancelButtonTitle,
                                                style: .cancel,
                                                handler: nil))
        alertController.addAction(UIAlertAction(title: Constants.signOutButtonTitle,
                                                style: .destructive,
                                                handler: { _ in
            try? Auth.auth().signOut()
        }))
        present(alertController, animated: true)
    }
}
