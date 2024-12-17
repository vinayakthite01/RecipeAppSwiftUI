//
//  Environment.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import Foundation

public enum EnvironmentData {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("*** Plist file not found ***")
        }
        return dict
    }()
    
    // MARK: - Plist values
    static let baseURL: String = {
        guard let baseURLString = EnvironmentData.infoDictionary[Keys.Plist.baseURL] as? String,
              baseURLString.count > 0 else {
            fatalError("*** Server URL not set in plist for this environment ***")
        }
        return baseURLString
    }()
}
