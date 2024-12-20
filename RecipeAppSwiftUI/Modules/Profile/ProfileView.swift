//
//  ProfileView.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 19/12/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ProfileView: View {
    let dependencyContainer: DependencyContainerProtocol
    @ObservedObject private var viewModel: ProfileViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showImagePicker = false
    @State private var useCamera = false
    @State private var selectedImage: UIImage?
    @State private var showActionSheet = false

    init(dependencyContainer: DependencyContainerProtocol) {
        viewModel = ProfileViewModel(coreDataService: dependencyContainer.coredataService)
        self.dependencyContainer = dependencyContainer
    }

    var body: some View {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if let user = viewModel.user {
                    Button(action: {
                        showActionSheet = true
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                        } else if let imageData = user.profileImage, let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                        }
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("Profile Image"), message: Text("Choose an option"), buttons: [
                            .default(Text("Select from Photo Library")) {
                                useCamera = false
                                showImagePicker = true
                            },
                            .default(Text("Take Photo")) {
                                useCamera = true
                                showImagePicker = true
                            },
                            .cancel()
                        ])
                    }
                    Text(user.username)
                        .font(.largeTitle)
                        .padding()

                    // MapView added here
                    MapView(region: $region)
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Text("No user found")
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                guard let username = UserDefaults.standard.string(forKey: "loggedinUser") else {
                    return
                }
                viewModel.fetchUserDetails(username:username)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: useCamera ? .camera : .photoLibrary)
            }
        }
}
