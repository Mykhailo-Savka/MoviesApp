//
//  ViewControllerRepresentable.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 27.03.2023.
//

import UIKit

protocol ViewControllerRepresentable: AnyObject {
    var view: UIView! { get }
}
