//
//  UIViewController+Loader.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 02.04.2023.
//

import UIKit

extension UIViewController {
    func addLoader(activityIndicator: UIActivityIndicatorView) {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.isHidden = true
    }
    
    func showLoaderIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoaderIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
