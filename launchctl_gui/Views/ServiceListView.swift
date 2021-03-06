//
//  ServiceView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/17/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceListView: View {
    let wrapper: Wrapper
    let list: [Service]

    @State private var selection: String?
    @State var searchText = ""

    init(wrapper: Wrapper) {
        self.wrapper = wrapper
        list = wrapper.get_user_list()
    }
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    SearchBar(searchText: $searchText)
                        .padding(.top)
                    List(selection: $selection) {
                        ForEach(list.filter { self.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchText) }) { s in
                            NavigationLink(destination: ServiceView(service: s, wrapper: self.wrapper)){
                                ServiceViewRow(service: s)
                            }
                        }
                    }
                }
    //                .navigationBarSearch(self.$searchText)
                    .frame(minWidth: 300)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ServiceListView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceListView(wrapper: Wrapper())
    }
}
