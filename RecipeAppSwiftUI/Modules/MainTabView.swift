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
    
    /*
    var popOver: some View {
           Group {
               if true {
                   ZStack(alignment: .bottom) {
                           Color.black.opacity(0.4).ignoresSafeArea()
                           ZStack {
                               Rectangle()
                                   .fill(.orange)
                                   .frame(maxWidth: .infinity, maxHeight: 60.0, alignment: .)
                           }
                       }
                       //.ignoresSafeArea()     // << probably you also need this
                       .onTapGesture {
//                           showSheet.toggle()
                       }
               }
           }
       }
    */
    
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
            CartView(dependencyContainer: dependency)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
            ProfileView(dependencyContainer: dependency)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
//        .overlay(popOver)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(dependency: DependencyContainer())
    }
}
