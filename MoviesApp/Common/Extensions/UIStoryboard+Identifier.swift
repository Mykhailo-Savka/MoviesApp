//
//  UIStoryboard+Identifier.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 27.03.2023.
//

import UIKit

extension UIStoryboard {
    var identifier: String {
        return String(describing: self)
    }
}
