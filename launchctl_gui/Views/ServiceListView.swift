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
    let emptyService = ServiceView(service: Service(given_string: ["0", "0", "-"]), wrapper: Wrapper())
    
    @State var list: [Service] = []
    // I hate that I init empty service twice, but I also don't know how else to
    // get this to work
    @State var current_view: ServiceView = ServiceView(service: Service(given_string: ["0", "0", "-"]), wrapper: Wrapper())
    @State var searchText = ""

    init(wrapper: Wrapper) {
        self.wrapper = wrapper
        list = self.wrapper.get_user_list()
//        var timer = Timer()
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self.update_list, repeats: true)
    }
    
    var body: some View {
        GeometryReader { metrics in
            HSplitView {
                VStack {

                    Button("Refresh Service List") {
                        list = wrapper.get_user_list()
                    }
                    .padding()

                    SearchBar(searchText: $searchText)
                
                    // List of services (links)
                    List {
                        ForEach (list.filter {
                            // Filter by searchbar text
                            self.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchText)
                        })
                        { matched_service in
                            // matched_service.name.capitalized
                            
                            Button(action: {
                                let new_view = ServiceView(service: matched_service, wrapper: self.wrapper)
                                
                                if (new_view.service.name == current_view.service.name) {
                                    current_view = emptyService
                                } else {
                                    current_view = new_view
                                }
                            }) {
                                ServiceListViewRow(service: matched_service)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(matched_service == current_view.service ?
                                            Color.accentColor : nil)
//                                .padding() // cuases bad effects we should try keeping it all inside the componenet?

                        }
                    }
                    .frame(minWidth: metrics.size.width * 0.25, maxWidth: metrics.size.width * 0.75)
                }
                
                current_view
                    .frame(minWidth: metrics.size.width * 0.25, maxWidth: metrics.size.width * 0.75)
            }
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ServiceListView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceListView(wrapper: Wrapper())
    }
}
