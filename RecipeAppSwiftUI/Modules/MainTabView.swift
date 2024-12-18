//
//  MainTabView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    let dependency: DependencyContainerProtocol
    var body: some View {
        TabView {
            CategoriesView(dependencyContainer: dependency)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView(dependencyContainer: dependency)
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

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(dependency: DependencyContainer())
    }
}
