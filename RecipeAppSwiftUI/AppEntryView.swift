//
//  AppEntryView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 16/12/24.
//

import SwiftUI
import CoreData

struct AppEntryView: View {
    let dependencyContainer: DependencyContainerProtocol
    @StateObject private var authService = AuthenticationService()
    
    var body: some View {
        NavigationView {
            VStack {
                if authService.isLoggedIn {
                    MainTabView(dependency: dependencyContainer)
                } else {
                    LoginView(dependencyContainer: dependencyContainer)
                }
            }
            .onAppear {
                authService.checkIfLoggedIn()
            }
        }
    }
}
