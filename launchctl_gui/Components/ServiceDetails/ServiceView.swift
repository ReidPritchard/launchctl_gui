//
//  ServiceView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/18/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceView: View {
    @Binding var service: Service
    let wrapper: Wrapper
    
    @State private var toggle_kickstart = true
    @State private var toggle_additional_info = false
    @State private var additional_props: [String: [[String: String]]]? = nil
    @State private var filepath: String = ""
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                headerView
                Spacer()
                serviceInfo
                quickActions
                additionalInfoToggleButton
                Spacer()
                
                if toggle_additional_info {
                    ServiceAdditionalDetails(additional_props: additional_props)
                }
            }
            .onAppear {
                refreshService()
            }
            .frame(minWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        Text(service.name)
            .font(.title)
            .lineLimit(2)
            .padding()
    }
    
    var serviceInfo: some View {
        HStack {
            Spacer()
            
            if !service.status_description.isEmpty {
                Text(service.status_description)
                    .padding()
                    .font(.headline)

                VStack(alignment: .leading) {
                    Text("Status:")
                        .font(.headline)
                    Text(service.status)
                        .font(.subheadline)
                }
                .padding()
            }

            VStack(alignment: .leading) {
                Text("PID:")
                    .font(.headline)
                Text(service.pid)
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
        }
    }
    
    var quickActions: some View {
        VStack {
            HStack {
                actionButton(title: "􀊃 Start", action: { print("start") })
                
                if toggle_kickstart {
                    actionButton(title: "􀊕 Kickstart", action: {
                        self.toggle_kickstart = self.wrapper.kickstart_service(service: self.service)
                    })
                } else {
                    Text("Kickstarting!")
                }
                
                actionButton(title: "Run Stats", action: { print("runstats") })
                actionButton(title: "􀜪 Stop", action: { print("stop") })
                actionButton(title: "􀁠 Remove", action: { print("remove") })
                
                actionButton(title: "Refresh", action: {
                    refreshService()
                    self.toggle_additional_info = true
                })
                
                actionButton(title: "Unload", action: {
                    print("Unload plist")
                    // TODO: Get associated plist file from service, then call wrapper.unload_plist(filepath: ...)
                })
            }
        }
    }
    
    var additionalInfoToggleButton: some View {
        Button(action: {
            withAnimation {
                toggle_additional_info.toggle()
                refreshService()
                additional_props = service.additional_properties
            }
        }) {
            Text("􀕹 Toggle Additional Info")
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding()
    }
    
    // MARK: - Helper Functions
    
    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
        }
    }
    
    private func refreshService() {
        self.wrapper.refresh_service(service: self.service)
        self.additional_props = service.additional_properties
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(service: .constant(Service(given_string: ["0", "10", "A neat name :)"])), wrapper: Wrapper())
    }
}
