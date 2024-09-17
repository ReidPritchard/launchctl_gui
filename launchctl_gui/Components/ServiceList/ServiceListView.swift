//
//  ServiceView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/17/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ServiceListView: View {
    @Binding var selectedService: Service
    @Binding var list: [Service]
    
    @State private var searchText = ""
    
    var filteredServices: [Service] {
        list.filter {
            searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                refreshButton
                
                SearchBar(searchText: $searchText)
                    .padding()
                
                servicesList(metrics: metrics)
            }
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Subviews
    
    private var refreshButton: some View {
        Button(action: {
            withAnimation {
                refreshServices()
            }
        }) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Refresh Service List")
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding()
    }
    
    private func servicesList(metrics: GeometryProxy) -> some View {
        List {
            ForEach(filteredServices, id: \.id) { matchedService in
                Button(action: {
                    selectedService = matchedService
                }) {
                    ServiceListViewRow(service: matchedService)
                }
                .listRowInsets(EdgeInsets())
                .buttonStyle(PlainButtonStyle())
                .background(matchedService == selectedService ? Color.accentColor.opacity(0.2) : nil)
            }
        }
        .frame(minWidth: metrics.size.width * 0.25, maxWidth: metrics.size.width * 0.75)
    }
    
    // MARK: - Helper Methods
    
    private func refreshServices() {
        // Insert logic to refresh services
        print("Services refreshed!")
    }
}

struct ServiceListView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceListView(selectedService: .constant(Service()), list: .constant([]))
    }
}
