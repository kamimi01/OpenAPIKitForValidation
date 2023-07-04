//
//  ContentView.swift
//  OpenAPIKitForValidation
//
//  Created by mikaurakawa on 2023/07/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button(action: {
                let url = Bundle.main.url(forResource: "openapi", withExtension: "yaml")
                let validator = OpenAPIDocValidator(url: url)
                validator.validate()
            }) {
                Text("ドキュメント検証")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
