//
//  String+NotNil.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 02.04.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var notNil: String {
        switch self {
        case .none:
            return ""
        case .some(let text):
            return text
        }
    }
}
