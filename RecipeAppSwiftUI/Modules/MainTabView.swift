//
//  MainTabView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 10/12/24.
//

import SwiftUI

enum Tab {
    case home, search, favorites, settings
}

// MARK: - MainTabView
struct MainTabView: View {
    let dependency: DependencyContainerProtocol
    @State private var selectedTab: Tab = .home
    
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
            SavedRecipesView(dependencyContainer: dependency)
                .tabItem {
                    Label("Saved", systemImage: "heart")
                }
            ProfileView(dependencyContainer: dependency)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(dependency: DependencyContainer())
    }
}
