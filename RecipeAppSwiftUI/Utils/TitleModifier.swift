//
//  TitleModifier.swift
//  RecipeAppSwiftUI
//
//  Created by Vinayak Thite on 27/12/24.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
#Preview {
    Text("Hello, World!")
        .modifier(Title())
}