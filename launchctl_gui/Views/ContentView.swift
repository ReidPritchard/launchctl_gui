//
//  ContentView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/14/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private let w = Wrapper()

    var body: some View {
        VStack{
            ActionBar(wrapper: w).padding(.top)
            
            HStack {
                ServiceListView(wrapper: w)
            }
        }
        .frame(minWidth: 600, maxWidth: 1000, minHeight: 300, maxHeight: 900)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
