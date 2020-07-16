//
//  ContentView.swift
//  launchctl_gui
//
//  Created by Reid Pritchard on 7/14/20.
//  Copyright © 2020 Reid Pritchard. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let w: Wrapper

    @State private var list: [Service] = []
    @State private var show_list = true
    var help: String
    @State private var show_help = true

    init?() {
        self.w = Wrapper.init()
        
        self.help = self.w.get_help()
        self.list = self.w.get_list()
    }
    
    var body: some View {
        HStack {
            ScrollView {
                VStack {
                    Button(action: {self.show_help = !self.show_help}, label: {Text("Show Help")} )
                    Text(self.help)
                        .padding()
                        .disabled(self.show_help)
                        .opacity(self.show_help ? 100 : 0)
                        .frame(height: self.show_help ? nil : 0)
                    
                }.padding()
            }
            ScrollView {
                VStack {
                    Button(action: {
                        self.show_list = !self.show_list
                        if (self.show_list) {
                            self.list = self.w.get_list()
                        }
                    }, label: {
                        Text("Launchctl List")
                    })
                    List(self.list, rowContent: { s in
                        Text("Name: " + s.status)
                    })
                        .padding()
                        .disabled(self.show_list)
                        .opacity(self.show_list ? 100 : 0)
                        .frame(height: self.show_list ? nil : 0)
                        
                }.padding()
            }
        }
        .frame(minWidth: 500)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
