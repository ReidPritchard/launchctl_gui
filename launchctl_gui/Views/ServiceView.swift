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
    @State private var toggle_additional_info = false
    @State var additional_props: [String : [[String : String]]]?
    @State private var filepath: String = ""
    
    init(service: Service, wrapper: Wrapper) {
        self.service = service
        self.wrapper = wrapper
        
        self.wrapper.refresh_service(service: self.service)
        self.additional_props = service.additional_properties
    }
    
    var serviceInfo: some View {
        HStack {
            Spacer()

            if service.status_description != "" {
            Text(service.status_description)
                .padding()
                .font(.headline)

            VStack (alignment: .leading) {
                Text("Status: ")
                    .font(.headline)
                Text(service.status)
                    .font(.subheadline)
            }.padding()
            }

            VStack (alignment: .leading) {
            Text("PID: ")
                .font(.headline)
            Text(service.pid)
                .font(.subheadline)
            }.padding()

            Spacer()
        }
    }
    
    var quickActions: some View {
        VStack {
            Group {
                HStack {
                    Button(action: {
                        print("start")
                    }) {
                        Text("􀊃 Start")
                    }
                
                    
                    if (toggle_kickstart){
                        Button(action: {
                            self.toggle_kickstart = self.wrapper.kickstart_service(service: self.service)
                        }) {
                            Text("􀊕 Kickstart")
                        }
                    } else {
                        Text("Kickstarting!")
                    }
                    
                    Button(action: {
                        // Prints performance statistics for a service.
                        print("runstats")
                    }) {
                        Text("Run Stats")
                    }
                    
                    Button(action: {
                        print("stop")
                    }) {
                        Text("􀜪 Stop")
                    }

                    Button(action: {
                        print("remove")
                    }) {
                        Text("􀁠 Remove")
                    }
                    
                    Button(action: {
                        self.wrapper.refresh_service(service: self.service)
                        self.toggle_additional_info = true
//                            print(self.service.additional_properties.count)
                    }) {
                        Text("Refresh")
                    }

                    Button(action: {
                        print("Unload plist")
                        // TODO: Get associated plist file from service, then call wrapper.unload_plist(filepath: ...)
                    }) {
                        Text("Unload")
                    }
                }
            }
        }
    }
    
//    var detailedInfo: some View {
//        List {
//            ForEach(self.additional_props?.keys.sorted() ?? ["Seems to be an issue. Try refreshing or toggling additional details."], id: \.self) { key in
//                Group{
//                    Text("\(key): ")
//                        .font(.headline)
//                        .bold()
//                    VStack(alignment: .leading) {
//                        ForEach(self.service.additional_properties[key] ?? [], id: \.self) {
//                            sub_dict in
//                            HStack {
//                                TextField("\(Array(sub_dict.keys)[0]): ")
//                                    .font(.subheadline)
//                                    .bold()
//
////                                            Text("\(Array(sub_dict.keys)[0]): ")
////                                                .font(.subheadline)
////                                                .bold()
//                                Text("\(sub_dict[Array(sub_dict.keys)[0]]!)").lineLimit(2)
//                            }
//                        }
//                    }
//                    .padding(.leading, 45)
//                }
//            }
//        }.padding()
//    }

    var body: some View {
        GeometryReader { metrics in
            VStack {
                Text(service.name)
                    .font(.title)
                    .lineLimit(2)
                    .padding()
                
                Spacer()
                
//                self.serviceInfo
                
//                self.quickActions
                
                
                Button(action: {
                     // , isOn: $toggle_additional_info
                    
                        withAnimation {
                            toggle_additional_info.toggle()
                            
                            self.wrapper.refresh_service(service: self.service)
                            self.additional_props = service.additional_properties
                        }
                }) {
                    Text("􀕹 Toggle Additional Info")
//                        .imageScale(.large)
//                        .scaleEffect(toggle_additional_info ? 0.8 : 1)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()

                Spacer()

                
                if self.toggle_additional_info {
//                    self.detailedInfo
                }

            }.frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(service: Service(given_string: ["0", "10", "A neat name :)"]), wrapper: Wrapper())
    }
}
