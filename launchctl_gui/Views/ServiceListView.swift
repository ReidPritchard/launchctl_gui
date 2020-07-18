//
//  ServiceView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/17/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceListView: View {
    let list: [Service]
    @State private var selection: String?
        
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                Section(header: Text("Services")) {
                    ForEach(list) { s in
                        NavigationLink(destination: ServiceView(service: s)){
                            ServiceViewRow(service: s)
                        }
                    }
                }
            }
        }.frame(minWidth: 100, maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ServiceListView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceListView(list: [Service(given_string: ["10", "10", "test_name"]), Service(given_string: ["10", "10", "test_name"]), Service(given_string: ["10", "10", "test_name"]), Service(given_string: ["10", "10", "test_name"])])
    }
}
