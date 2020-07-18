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
        HStack {
            ServiceListView(wrapper: w)
        }
        .frame(minWidth: 600, minHeight: 300)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
