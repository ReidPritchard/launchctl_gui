//
//  ServiceViewRow.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/17/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceListViewRow: View {
    let service: Service
    
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                Text("Status: " + service.status)
                    .font(.subheadline)
                    .lineLimit(1)
                    .padding(.trailing, 5.0)
                VStack(alignment: .leading) {
                    Text(service.name)
                        .font(.headline)
                        .minimumScaleFactor(0.5)
                    Text("PID: " + service.pid)
                        .font(.subheadline)
                }
                
                Spacer()
                
//                pLineArrow
            }

            Divider()
                   .padding([.leading, .trailing], 30)
        }
//        .frame(minHeight: 30)
//        .padding()
        
//        Text("Status: " + service.name)
    }
}

struct ServiceListViewRow_Previews: PreviewProvider {
    static var previews: some View {
        ServiceListViewRow(service: Service(given_string: ["10", "10", "This is the name :0 Wowzers"]))
    }
}
