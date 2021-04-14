//
//  MainServiceView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 4/2/21.
//  Copyright © 2021 Reid Pritchard. All rights reserved.
//

import SwiftUI

// Really not sure if I should split this or not, servicelistview is getting quite messy and I can't get the formatting right
// Spliting it would be good, but also I need to rework how the variables are passed so I don't use an anti-pattern or whatever

struct MainServiceView: View {
    let wrapper: Wrapper
    
    @State var list: [Service] = []
    @State var current_view: ServiceView = ServiceView(service: Service(given_string: ["0", "0", "-"]), wrapper: Wrapper())
    @State var searchText = ""

    init(wrapper: Wrapper) {
        self.wrapper = wrapper
        list = wrapper.get_user_list()
    }
    
    var body: some View {
        GeometryReader { metrics in
            HSplitView {
                ServiceListView(wrapper: wrapper)
                    .frame(minWidth: metrics.size.width * 0.25, maxWidth: metrics.size.width * 0.75)
                
                current_view
                    .frame(minWidth: metrics.size.width * 0.25, maxWidth: metrics.size.width * 0.75)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainServiceView_Previews: PreviewProvider {
    static var previews: some View {
        MainServiceView(wrapper: Wrapper())
    }
}
