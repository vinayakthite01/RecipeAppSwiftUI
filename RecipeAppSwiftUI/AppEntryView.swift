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
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LoginView(dependencyContainer: dependencyContainer)) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: RegistrationView(dependencyContainer: dependencyContainer)) {
                    Text("Register")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
