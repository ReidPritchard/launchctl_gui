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
    let wrapper: Wrapper
    
    @State var toggle_kickstart = true
    @State var toggle_additional_info = false

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
            
            HStack {
                VStack {
                    if (toggle_kickstart){
                        Button(action: {
                            self.toggle_kickstart = self.wrapper.kickstart_service(service: self.service)
                        }) {
                            Text("Kickstart")
                        }
                    } else {
                        Text("Kickstarting!")
                    }
                }
                
                Button(action: {
                    self.wrapper.refresh_service(service: self.service)
                    self.toggle_additional_info = true
                    print(self.service.additional_properties.count)
                }) {
                    Text("Refresh")
                }
            }
            
            Spacer()
            
            if self.toggle_additional_info {
                List {
                    ForEach(service.additional_properties.keys.sorted(), id: \.self) { key in
                        Section{
                            Text("\(key): ")
                                .font(.headline)
                                .bold()
                            VStack(alignment: .leading) {
                                ForEach(self.service.additional_properties[key] ?? [], id: \.self) {
                                    sub_dict in
                                    HStack {
                                        Text("\(Array(sub_dict.keys)[0]): ")
                                            .font(.subheadline)
                                            .bold()
                                        Text("\(sub_dict[Array(sub_dict.keys)[0]]!)")
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }.padding()
            }

        }.frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(service: Service(given_string: ["0", "10", "A neat name :)"]), wrapper: Wrapper())
    }
}
