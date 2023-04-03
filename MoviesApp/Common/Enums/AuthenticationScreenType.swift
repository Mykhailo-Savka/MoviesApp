//
//  AuthenticationScreenType.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 30.03.2023.
//

import Foundation

// MARK: - AuthenticationScreenType
enum AuthenticationScreenType {
    case signIn
    case signUp
    
    var title: String {
        switch self {
        case .signIn:
            return Constants.signIn
        case .signUp:
            return Constants.signUp
        }
    }
    
    var accountTitle: String {
        switch self {
        case .signIn:
            return Constants.signInAccountTitle
        case .signUp:
            return Constants.signUpAccountTitle
        }
    }
    
    var accountButtonTitle: String {
        switch self {
        case .signIn:
            return Constants.signUp
        case .signUp:
            return Constants.signIn
        }
    }
    
    var isHidden: Bool {
        return self == .signIn
    }
}
