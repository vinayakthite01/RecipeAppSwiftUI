//
//  Extension.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 13/12/24.
//

import SwiftUI

extension View {
    func navigationLinkValues<D>(_ data: D.Type) -> some View where D : Hashable & View {
        NavigationStack {
            self.navigationDestination(for: data, destination: { $0 })
        }
    }
}
