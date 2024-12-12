//
//  DateFormatter+Extension.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 04/12/24.
//

import Foundation

extension DateFormatter {
    static let posixLocale = Locale(identifier: "en_US_POSIX")

    /// "2017-01-15T11:16:11.000Z"
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = posixLocale
        return formatter
    }()
}
