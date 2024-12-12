//
//  MainTabView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    var body: some View {
        TabView {
            let categoriesBuilder = CategoriesBuilder(apiService: APIService())
            categoriesBuilder.build()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
