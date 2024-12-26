//
//  Registration.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 16/12/24.
//

import SwiftUI

struct RegistrationView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject private var viewModel: RegistrationViewModel
    @State var usernameInputString = ""
    @State var passwordInputString = ""
    
    init(dependencyContainer: DependencyContainerProtocol) {
        self.dependencyContainer = dependencyContainer
        _viewModel = ObservedObject(wrappedValue: RegistrationViewModel(coredataService: dependencyContainer.coredataService))
    }
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
                .frame(width: 350, height: 50, alignment: .center)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 5)
                .overlay(Rectangle().stroke(Color.gray))
                .padding()
                .onChange(of: usernameInputString) {
                    viewModel.errorMessage = nil
                }
            
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
                .frame(width: 350, height: 50, alignment: .center)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 5)
                .overlay(Rectangle().stroke(Color.gray))
                .padding()
                .onChange(of: passwordInputString) {
                    viewModel.errorMessage = nil
                }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
                    .padding()
            }
            
            if let successMessage = viewModel.successMessage {
                Text(successMessage).foregroundColor(.green)
                    .padding()
            }
            
            Button(action: {
                let validation = viewModel.validate()
                if validation {
                    viewModel.register()
                }
            }) {
                Text("Register")
                    .padding()
                    .frame(width: 140.0, height: 60.0)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding([.top, .bottom])
            
            Rectangle()
                .fill(.white)
                .frame(height: 60.0)
        }
        .navigationTitle("Register")
        .padding()
    }
}


#Preview {
    RegistrationView(dependencyContainer: DependencyContainer())
}
