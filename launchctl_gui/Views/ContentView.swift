//
//  ContentView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/14/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let wrapper: Wrapper
    
    var body: some View {
        VStack {
            ActionBar(wrapper: wrapper)
                .padding(.top)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Service Manager")
                            .font(.headline)
                    }
                }
            
            // Main content area
            ServiceListSection(wrapper: wrapper)
                .frame(minWidth: 600, maxWidth: 1000, minHeight: 300, maxHeight: 900)
        }
    }
}

struct ServiceListSection: View {
    let wrapper: Wrapper
    
    var body: some View {
        HStack {
            ServiceListView(selectedService: .constant(Service()), list: .constant(wrapper.get_user_list()))
                .layoutPriority(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(wrapper: Wrapper())
    }
}
