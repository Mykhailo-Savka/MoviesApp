//
//  AuthenticationViewController.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 28.03.2023.
//

import UIKit

// MARK: - AuthenticationViewControllerProtocol
protocol AuthenticationViewControllerProtocol: AnyObject {
    func setupUI(with type: AuthenticationScreenType)
    func createAlert(with message: String)
    func showMoviesTabBarController(name: String?, email: String?, imageURL: URL?)
    func presentActionSheet()
    func showLoader()
    func hideLoader()
}

// MARK: - AuthenticationViewController
final class AuthenticationViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var authenticationButton: UIButton!
    @IBOutlet private weak var authenticationTitle: UILabel!
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var accountButton: UIButton!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
    // MARK: - Public properties
    var presenter: AuthenticationViewPresenterProtocol!
    
    // MARK: - Private properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }
    
    // MARK: - Private methods
    private func setupShowPasswordButton(isSelected: Bool) {
        showPasswordButton.setImage(isSelected ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye"),
                                    for: .normal)
        passwordTextField.isSecureTextEntry = !isSelected
    }
    
    // MARK: - IBActions
    @IBAction private func nameTextFieldChanged(_ sender: UITextField) {
        presenter.nameDidChanged(sender.text.notNil)
    }
    
    @IBAction private func emailTextFieldChanged(_ sender: UITextField) {
        presenter.emailDidChanged(sender.text.notNil)
    }
    
    @IBAction private func passwordTextFieldChanged(_ sender: UITextField) {
        presenter.passwordDidChanged(sender.text.notNil)
    }
    
    @IBAction private func onLoginButton(_ sender: UIButton) {
        presenter.authentication()
    }
    
    @IBAction private func onAccountButton(_ sender: UIButton) {
        presenter.accountButtonTapped()
    }
    
    @IBAction private func onAddPhotoButton(_ sender: UIButton) {
        presenter.presentActionSheet()
    }
    
    @IBAction private func onShowPasswordButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        setupShowPasswordButton(isSelected: !sender.isSelected)
    }
    
}

// MARK: - AuthenticationViewControllerProtocol implementation
extension AuthenticationViewController: AuthenticationViewControllerProtocol {
    func setupUI(with type: AuthenticationScreenType) {
        titleLabel.text = type.title
        authenticationButton.setTitle(type.title, for: .normal)
        nameView.isHidden = type.isHidden
        authenticationTitle.text = type.accountTitle
        accountButton.setTitle(type.accountButtonTitle, for: .normal)
        userImage.isHidden = type.isHidden
        addPhotoButton.isHidden = type.isHidden
        hideKeyboardWhenTappedAround()
        nameTextField.text = nil
        emailTextField.text = nil
        passwordTextField.text = nil
        addLoader(activityIndicator: activityIndicator)
    }
    
    func createAlert(with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.okButtonTitle,
                                                style: .cancel,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    func showMoviesTabBarController(name: String?, email: String?, imageURL: URL?) {
        let moviesTabBarController = MoviesTabBarController.instantiateFromStoryboard()
        moviesTabBarController.name = name
        moviesTabBarController.email = email
        moviesTabBarController.imageURL = imageURL
        moviesTabBarController.modalPresentationStyle = .fullScreen
        present(moviesTabBarController, animated: true)
    }
    
    func presentActionSheet() {
        let imagePikerController = UIImagePickerController()
        imagePikerController.delegate = self
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: Constants.photoButtonTitle,
                                             style: .default, handler: { _ in
                imagePikerController.sourceType = .camera
                self.present(imagePikerController, animated: true, completion: nil)
            })
            actionSheet.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: Constants.galleryButtonTitle,
                                          style: .default, handler: { _ in
            imagePikerController.sourceType = .photoLibrary
            self.present(imagePikerController, animated: true, completion: nil)
        })
        
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(UIAlertAction(title: Constants.cancelButtonTitle,
                                            style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showLoader() {
        showLoaderIndicator(activityIndicator: activityIndicator)
    }
    
    func hideLoader() {
        hideLoaderIndicator(activityIndicator: activityIndicator)
    }
}

// MARK: - UIImagePickerControllerDelegate implementation
extension AuthenticationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        userImage.image = image
        presenter.getUserImage(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
