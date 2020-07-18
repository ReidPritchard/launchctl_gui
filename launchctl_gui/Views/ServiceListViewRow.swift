//
//  ServiceViewRow.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/17/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceViewRow: View {
    let service: Service
    
    var body: some View {
        HStack {
            Text(service.status)
                .font(.subheadline)
                .lineLimit(1)
                .padding(.trailing, 5.0)
            VStack(alignment: .leading) {
                Text(service.name)
                    .font(.headline)
                Text(service.pid)
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

struct ServiceViewRow_Previews: PreviewProvider {
    static var previews: some View {
        ServiceViewRow(service: Service(given_string: ["10", "10", "This is the name :0 Wowzers"]))
    }
}
