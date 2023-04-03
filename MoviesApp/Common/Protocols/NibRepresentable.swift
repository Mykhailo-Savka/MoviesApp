//
//  NibRepresentable.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 27.03.2023.
//

import UIKit

protocol NibRepresentable {
    static var nib: UINib { get }
    static var identifier: String { get }
}
