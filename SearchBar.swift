//
//  SearchBar.swift
//  launchctl_gui
//
//  I DID NOT MAKE THIS SEARCH BAR
//  I GOT IT FROM https://mobileinvader.com/search-bar-in-swiftui/
//  Just changed some little things for macOS vs iOS

import SwiftUI

struct SearchBar : View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchText, onCommit:  {
                NSApplication.shared.windows.first { $0.isKeyWindow }?.endEditing(for: true)
            })
          .padding(.leading, 10)
            Button(action: {
                self.searchText = ""
            }) {
                Text("Clear")
            }
        }.padding(.horizontal)
    }
}
