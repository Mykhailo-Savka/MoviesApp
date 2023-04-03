//
//  DateHelper.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 02.04.2023.
//

import Foundation

// MARK: - DateHelper
final class DateHelper {
    
    // MARK: - Public methods
    static func convertDate(from dateString: String) -> String? {
        let ISODateFormatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        if let date = ISODateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
