//
//  ServiceView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/18/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceView: View {
    let service: Service
    
    var body: some View {
        VStack {
            Text(service.name)
                .font(.title)
                .lineLimit(2)
                .padding()
            
            Spacer()
            
            HStack {
                Spacer()

                if service.status_description != "" {
                    Text(service.status_description)
                        .padding()
                        .font(.headline)
                }
                
                VStack (alignment: .leading) {
                    Text("PID: ")
                        .font(.headline)
                    Text(service.pid)
                        .font(.subheadline)
                }.padding()
                
                Spacer()
            }
            
            Spacer()

        }.frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(service: Service(given_string: ["0", "10", "A neat name :)"]))
    }
}
