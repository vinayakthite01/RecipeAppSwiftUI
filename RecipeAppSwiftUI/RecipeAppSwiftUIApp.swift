//
//  RecipeAppSwiftUIApp.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 03/12/24.
//

import SwiftUI
import Combine

@main
struct RecipeAppSwiftUIApp: App {

    let dependencyContainer = DependencyContainer()
    var body: some Scene {
        WindowGroup {
            AppEntryView(dependencyContainer: dependencyContainer)
        }
    }
}
